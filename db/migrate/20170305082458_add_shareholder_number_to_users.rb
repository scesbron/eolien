class AddShareholderNumberToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :shareholder_number, :integer
  end
end
