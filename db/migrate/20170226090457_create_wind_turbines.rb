class CreateWindTurbines < ActiveRecord::Migration[5.0]
  def change
    create_table :wind_turbines do |t|
      t.string :name
      t.string :reference

      t.timestamps
    end
  end
end
