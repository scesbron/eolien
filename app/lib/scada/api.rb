module Scada
  class Api

    URL = ENV['SCADA_URL']
    USERNAME = ENV['SCADA_USERNAME']
    PASSWORD = ENV['SCADA_PASSWORD']

    # maybe define on the farm
    CLIENT_VERSION = ENV['SCADA_CLIENT_VERSION']

    def self.login
      response = Typhoeus.post(
        "#{URL}/nc2/services/login",
        body: { connection: 'secure', userName: USERNAME, pw: PASSWORD, client: 'nc2' },
        timeout: 5,
        ssl_verifypeer: false,
        ssl_verifyhost: 0
      )
      response.headers['Set-Cookie']&.scan(/NC2SESSIONID=([a-zA-Z0-9]*);/)&.last&.first
    end

    def self.get_status_handle(session_id, wind_farm, fetch_interval = 10000)
      response = Typhoeus.post(
        "#{URL}/nc2/services/MessageService",
        body: get_status_handle_body(session_id, fetch_interval, wind_farm),
        headers: headers(session_id),
        ssl_verifypeer: false,
        ssl_verifyhost: 0
      )
      Hash.from_xml(response.body)['Envelope']['Body']['subscribeRealTimeValuesResponse']['handle']
    end

    def self.status(session_id, handle, wind_farm)
      nb_values = values().size
      response = Typhoeus.post(
        "#{URL}/nc2/services/MessageService",
        body: status_request(session_id, handle),
        headers: headers(session_id),
        timeout: 2,
        ssl_verifypeer: false,
        ssl_verifyhost: 0
      )
      values = Hash.from_xml(response.body)['Envelope']['Body']['getRealTimeValuesByHandleResponse']['kksArray'].scan(/(\{.*?\})?,?/)
      wind_farm.wind_turbines.map.with_index do |wind_turbine, index|
        WindTurbineStatus.new(
          wind_turbine.name,
          to_f(values[1 + index * nb_values]),
          to_f(values[0 + index * nb_values]),
          to_f(values[3 + index * nb_values]),
          to_f(values[2 + index * nb_values]),
        )
      end
    end

    def self.daily_production(session_id, wind_farm, date)
      response = Typhoeus.post("#{URL}/nc2/services/MessageService",
        body: daily_production_request(session_id, wind_farm, date),
        headers: headers(session_id),
        timeout: 2,
        ssl_verifypeer: false,
        ssl_verifyhost: 0
      )
      [Hash.from_xml(response.body)['Envelope']['Body']['getDailyReportResponse']['OL']['LI']].flatten.map do |str_value|
        values = str_value.split(',')
        Scada::DailyProduction.new(
          values[0].to_i, values[1].to_i, values[2].to_i, values[3].to_i, values[4].to_i,
          values[5].to_i, values[6].to_i, values[7].to_f, values[8].to_i, values[9].to_f,
          values[10].to_i, values[11].to_i
        )
      end
    end

    def self.parc_ten_minutes_values(session_id, start_date, end_date)
      request = parc_ten_minutes_values_request(session_id, start_date, end_date)
      response = Typhoeus.post("#{URL}/nc2/services/MessageService",
                               body: request,
                               headers: headers(session_id),
                               timeout: 10
                              )
      str_value = Hash.from_xml(response.body)['Envelope']['Body']['get10minValuesRangeResponse']['OL']['LI']
      str_value.split(',').map{ |value| value.to_f * 1000 }
    end

    def self.turbine_ten_minutes_values(session_id, name, start_date, end_date)
      request = turbine_ten_minutes_values_request(session_id, name, start_date, end_date)
      response = Typhoeus.post("#{URL}/nc2/services/MessageService",
                               body: request,
                               headers: headers(session_id),
                               timeout: 10
                              )
      Hash.from_xml(response.body)['Envelope']['Body']['get10minValuesRangeResponse']['OL']['LI'].map do |str_value|
        str_value.split(',').map{ |value| value.to_f }
      end
    end

    def self.headers(session_id)
      {
        'Content-Type'    => 'text/xml; charset=utf-8',
        'Cookie'          => "NC2SESSIONID=#{session_id}; NCIILanguage=fr; active-nc2-session=true"
      }
    end

    private

    def self.to_f(value)
      value&.first&.scan(/\{(\d+\.?\d*),.*}/)&.last&.first&.to_f
    end

    def self.get_status_handle_body(session_id, fetch_interval, wind_farm)
      %(<?xml version='1.0' encoding='utf-8'?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
  <SOAP-ENV:Header>
    <session xmlns="http://nordex-online.com/xml/nc2/client/#{CLIENT_VERSION}/">#{session_id}</session>
  </SOAP-ENV:Header>
  <SOAP-ENV:Body>
    <subscribeRealTimeValues>
      <RFCName>#{wind_farm.reference}</RFCName>
      <fetchInterval>#{fetch_interval}</fetchInterval>
      <maxMissedFetches>60</maxMissedFetches>
      <options>
        <returnValue>1</returnValue>
        <returnStatus>1</returnStatus>
        <returnSensorStatus>1</returnSensorStatus>
      </options>
      <kksList>
#{wind_farm.wind_turbines.flat_map { |turbine| wind_turbine_status(turbine) }.first}
      </kksList>
    </subscribeRealTimeValues>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>)
    end

    def self.wind_turbine_status(wind_turbine)
      values.map do |value|
        "        <kks>#{wind_turbine.wea_name}/#{value}</kks>"
      end.join("\n")
    end

    def self.values
      %w[_FARM_OVERVIEW1 _FARM_OVERVIEW2 _FARM_OVERVIEW3 _FARM_OVERVIEW4]
    end

    def self.status_request(session_id, handle)
      %(<?xml version='1.0' encoding='utf-8'?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
  <SOAP-ENV:Header>
    <session xmlns="http://nordex-online.com/xml/nc2/client/#{CLIENT_VERSION}/">
      #{session_id}
    </session>
  </SOAP-ENV:Header>
  <SOAP-ENV:Body>
    <getRealTimeValuesByHandle>
      <handle>#{handle}</handle>
    </getRealTimeValuesByHandle>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>)
    end

    def self.daily_production_request(session_id, wind_farm, date)
      %(<?xml version='1.0' encoding='utf-8'?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
  <SOAP-ENV:Header>
    <ns1:session xmlns:ns1="http://nordex-online.com/xml/nc2/client/#{CLIENT_VERSION}/">
      #{session_id}
    </ns1:session>
  </SOAP-ENV:Header>
  <SOAP-ENV:Body>
    <getDailyReport>
      <weanameList>
#{wind_farm.wind_turbines.flat_map { |turbine| "        <weaname>#{turbine.wea_name}</weaname>" }.first}
      </weanameList>
      <kksList>
        <kks>TIMER01.daily</kks>
        <kks>PERIOD_RUNTIME</kks>
        <kks>PERIOD_AVAIL</kks>
        <kks>COUNT20.daily</kks>
        <kks>COUNT21.daily</kks>
        <kks>COUNT16.daily</kks>
        <kks>COUNT17.daily</kks>
        <kks>BHA10FE012.dailyav</kks>
        <kks>CAPACITY</kks>
        <kks>MDL10FS001.dailyav</kks>
        <kks>TIMER05.daily</kks>
        <kks>TIMER08.daily</kks>
      </kksList>
      <fromDate>#{date.to_s}</fromDate>
    </getDailyReport>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>)
    end

    def self.parc_ten_minutes_values_request(session_id, start_date, end_date)
      %(<?xml version='1.0' encoding='utf-8'?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
  <SOAP-ENV:Header>
    <ns1:session xmlns:ns1="http://nordex-online.com/xml/nc2/client/13/">#{session_id}</ns1:session>
  </SOAP-ENV:Header>
  <SOAP-ENV:Body>
    <get10minValuesRange>
      <RFCName>01CWE5626</RFCName>
      <kksList>
        <kks>ANA17.10mav</kks>
      </kksList>
      <fromDateTime>#{start_date.strftime('%Y-%m-%d-%H:%M')}</fromDateTime>
      <toDateTime>#{end_date.strftime('%Y-%m-%d-%H:%M')}</toDateTime>
    </get10minValuesRange>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>)
    end


    def self.turbine_ten_minutes_values_request(session_id, name, start_date, end_date)
      %(<?xml version='1.0' encoding='utf-8'?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
  <SOAP-ENV:Header>
    <ns1:session xmlns:ns1="http://nordex-online.com/xml/nc2/client/13/">#{session_id}</ns1:session>
  </SOAP-ENV:Header>
  <SOAP-ENV:Body>
    <get10minValuesRange>
      <RFCName>#{name}</RFCName>
      <kksList>
        <kks>ANA097.10mav</kks>
        <kks>MDL10FS001.10mav</kks>
        <kks>MDL10FG001.10mav</kks>
        <kks>ANA085.10mav</kks>
      </kksList>
      <fromDateTime>#{start_date.strftime('%Y-%m-%d-%H:%M')}</fromDateTime>
      <toDateTime>#{end_date.strftime('%Y-%m-%d-%H:%M')}</toDateTime>
    </get10minValuesRange>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>)
    end
  end
end
