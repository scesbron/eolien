class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :civility, :string, after: :last_sign_in_ip
    add_column :users, :maiden_name, :string, after: :lastname
    add_column :users, :birth_date, :date
    add_column :users, :birth_country, :string
    add_column :users, :birth_department, :string
    add_column :users, :birth_city_code, :string
    add_column :users, :birth_city, :string
    add_column :users, :additional_address, :string, after: :address
    add_column :users, :city_code, :string, after: :city
    add_column :users, :start_up_actions, :integer
    add_column :users, :first_round_actions, :integer
    add_column :users, :first_round_obligations, :integer
    add_column :users, :second_round_actions, :integer
    add_column :users, :second_round_obligations, :integer
  end
end
