class AddCweNameToWindFarms < ActiveRecord::Migration[6.0]
  def change
    add_column :wind_farms, :cwe_name, :string
  end
end
