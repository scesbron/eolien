class SendRealTimeDataToTraderJob < ApplicationJob

  DATE_FORMAT = '%d/%m/%Y %H:%M:%S'.freeze

  def perform(wind_farm)
    session_id = Scada::Api.login
    end_time = Time.at(Time.now.to_i - (Time.now.to_i % 10.minutes))
    start_time = end_time - 72.hours
    JobMailer.send_real_time_data_to_trader(
      wind_farm,
      generate_global_file(wind_farm, session_id, start_time, end_time),
      generate_unit_file(wind_farm, session_id, start_time, end_time)
    ).deliver_now!
  end

  private

  def generate_global_file(wind_farm, session_id, start_time, end_time)
    headers = ['DATE', 'GRID_P (kW)']

    CSV.generate(headers: true, col_sep: ';', force_quotes: true, encoding: Encoding::UTF_8) do |csv|
      csv << headers
      Scada::Api.parc_ten_minutes_values(session_id, wind_farm, start_time, end_time).reverse.each do |value|
        csv << [
          value.time.utc.strftime(DATE_FORMAT),
          value.active_power
        ]
      end
    end
  end

  def generate_unit_file(wind_farm, session_id, start_time, end_time)
    headers = ['DATE', 'WTG_Num', 'WTG_GD_P (kW)', 'WTG_OP_ST', 'WTG_WD_SPE (m/s)', 'WTG_WD_DIR (°)']

    CSV.generate(headers: true, col_sep: ';', force_quotes: true, encoding: Encoding::UTF_8) do |csv|
      csv << headers
      wind_farm.wind_turbines.enabled.each do |wind_turbine|
        Scada::Api.turbine_ten_minutes_values(session_id, wind_turbine, start_time, end_time).reverse.each do |value|
          csv << [
            value.time.utc.strftime(DATE_FORMAT),
            format('E%<number>02d', number: wind_turbine.number),
            value.active_power,
            value.operating_state,
            value.wind_speed,
            value.wind_direction
          ]
        end
      end
    end
  end
end
