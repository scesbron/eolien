class AddTurbinePowerToWindFarms < ActiveRecord::Migration[6.0]
  def change
    add_column :wind_farms, :turbine_power, :integer
  end
end
