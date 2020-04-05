class CreateBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|
      t.string :encrypted_bank_name
      t.string :encrypted_bank_name_iv
      t.string :encrypted_bic
      t.string :encrypted_bic_iv
      t.string :encrypted_iban
      t.string :encrypted_iban_iv
      t.belongs_to :user, index: { unique: true }, foreign_key: true

      t.timestamps
    end
  end
end
