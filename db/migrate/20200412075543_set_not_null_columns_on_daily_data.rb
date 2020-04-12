class SetNotNullColumnsOnDailyData < ActiveRecord::Migration[6.0]
  def change
    change_column :daily_data, :day, :date, null: false
    change_column :daily_data, :production, :float, null: false
    change_column :daily_data, :consumption, :float, null: false
    change_column :daily_data, :disponibility, :float, null: false
    change_column :daily_data, :wind_speed, :float, null: false
  end
end
