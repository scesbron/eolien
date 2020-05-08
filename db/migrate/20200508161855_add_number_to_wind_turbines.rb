class AddNumberToWindTurbines < ActiveRecord::Migration[6.0]
  def change
    add_column :wind_turbines, :number, :integer
  end
end
