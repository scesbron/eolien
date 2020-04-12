class CreateUserLoans < ActiveRecord::Migration[6.0]
  def change
    create_table :user_loans do |t|
      t.date :date, null: false
      t.integer :quantity, null: false
      t.references :loan, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
