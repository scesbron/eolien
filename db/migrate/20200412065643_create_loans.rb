class CreateLoans < ActiveRecord::Migration[6.0]
  def change
    create_table :loans do |t|
      t.string :name, null: false
      t.float :amount, null: false
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
    add_index :loans, :name, unique: true
  end
end
