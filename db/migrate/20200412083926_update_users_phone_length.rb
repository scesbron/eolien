class UpdateUsersPhoneLength < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :phone, :string, limit: 25
  end
end
