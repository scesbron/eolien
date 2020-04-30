desc 'This task is called by the Heroku scheduler add-on'
task update_daily_data: :environment do
  puts 'Updating daily data...'
  WindFarm.all.map do |wind_farm|
    ImportDailyDataJob.perform_now(wind_farm, 10.days.ago.to_date, 1.day.ago.to_date)
  end
  puts 'done.'
end
