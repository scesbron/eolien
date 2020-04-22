class AddColumnsToWindFarmsAndTurbines < ActiveRecord::Migration[6.0]
  def change
    add_column :wind_farms, :reference, :string
    add_column :wind_turbines, :wea_name, :string
  end
end
