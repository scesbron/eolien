class ImportDailyDataJob < ApplicationJob

  START_DATE = Date.new(2016, 11, 1)

  def perform(start_date, end_date)
    session_id = Scada::ParcStatus.login
    turbines = WindTurbine.order(:id)
    (start_date..end_date).each do |date|
      data = Scada::ParcStatus.daily_production(session_id, date)
      turbines.each_with_index do |turbine, index|
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
