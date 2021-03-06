class ImportDailyDataJob < ApplicationJob

  START_DATE = Date.parse(ENV['START_DATE'])

  def perform(wind_farm, start_date, end_date)
    session_id = Scada::Api.login
    turbines = wind_farm.wind_turbines.ordered_by_number.enabled
    ([START_DATE, start_date].max..end_date).each do |date|
      puts "Import data for the #{date}"
      data = Scada::Api.daily_production(session_id, wind_farm, date)
      turbines.each_with_index do |turbine, index|
        next unless data[index]

        datum = DailyDatum.find_or_create_by(day: date, wind_turbine: turbine)
        datum.update(
          production: data[index].production,
          consumption: data[index].consumption,
          disponibility: data[index].availability_rate,
          wind_speed: data[index].wind_speed
        )
      end
    end
  end
end
