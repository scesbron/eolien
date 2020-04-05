class CreateDailyData < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_data do |t|
      t.date :day
      t.references :wind_turbine, foreign_key: true
      t.float :production
      t.float :consumption
      t.float :disponibility
      t.float :wind_speed

      t.timestamps
    end
  end
end
