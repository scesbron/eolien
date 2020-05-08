class SendRealTimeDataToTraderJob < ApplicationJob

  DATE_FORMAT = '%d/%m/%Y %H:%M:%S'.freeze

  def perform(wind_farm)
    JobMailer.send_real_time_data_to_trader(
      wind_farm,
      generate_global_file(wind_farm),
      generate_unit_file(wind_farm)
    ).deliver_now!
  end

  private

  def generate_global_file(wind_farm)
    headers = ['DATE', 'GRID_P (kW)']

    CSV.generate(headers: true, col_sep: ';', force_quotes: true, encoding: Encoding::UTF_8) do |csv|
      csv << headers
      csv << [Time.now.strftime(DATE_FORMAT), 9569.053]
    end
  end

  def generate_unit_file(wind_farm)
    headers = ['DATE', 'WTG_Num', 'WTG_GD_P (kW)', 'WTG_OP_ST', 'WTG_WD_SPE (m/s)', 'WTG_WD_DIR (°)']

    CSV.generate(headers: true, col_sep: ';', force_quotes: true, encoding: Encoding::UTF_8) do |csv|
      csv << headers
      wind_farm.wind_turbines.enabled.each do |wind_turbine|
        csv << [
          Time.now.strftime(DATE_FORMAT),
          format('E%<number>02d', number: wind_turbine.number),
          3162.052,
          'RUN',
          10.227,
          223.878
        ]
      end
    end
  end
end
