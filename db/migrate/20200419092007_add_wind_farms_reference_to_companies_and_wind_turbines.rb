class AddWindFarmsReferenceToCompaniesAndWindTurbines < ActiveRecord::Migration[6.0]
  def change
    add_reference :companies, :wind_farm, foreign_key: true
    add_reference :wind_turbines, :wind_farm, foreign_key: true
    add_column :companies, :slug, :string
    add_index :companies, :slug, unique: true
  end
end

