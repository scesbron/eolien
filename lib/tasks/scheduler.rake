desc "This task is called by the Heroku scheduler add-on"
task update_daily_data: :environment do
  puts "Updating daily data..."
  ImportDailyDataJob.perform_now(10.days.ago.to_date, 1.day.ago.to_date)
  puts "done."
end
