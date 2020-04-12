class AddDetailsToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :legal_name, :string
    add_column :companies, :address, :string
    add_column :companies, :phone, :string
    add_column :companies, :email, :string
    add_column :companies, :legal_agent, :string
  end
end
