class CreateWindFarms < ActiveRecord::Migration[6.0]
  def change
    create_table :wind_farms do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps
    end
    add_index :wind_farms, :name, unique: true
    add_index :wind_farms, :slug, unique: true
  end
end
