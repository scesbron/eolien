class AddEnabledToWindTurbines < ActiveRecord::Migration[6.0]
  def change
    add_column :wind_turbines, :enabled, :boolean, default: true, null: false
  end
end
