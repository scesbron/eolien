class CreateProductibles < ActiveRecord::Migration[5.0]
  def change
    create_table :productibles do |t|
      t.integer :month
      t.string :name
      t.float :value

      t.timestamps
    end
  end
end
