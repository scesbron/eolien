class AddUsernameUniqIndexToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, :email
    add_index    :users, :email
    add_index    :users, :username, unique: true
  end
end
