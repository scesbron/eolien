class AddTraderColumnsToWindFarms < ActiveRecord::Migration[6.0]
  def change
    add_column :wind_farms, :trader_email, :string
    add_column :wind_farms, :trader_mail_subject, :string
  end
end
