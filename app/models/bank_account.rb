class BankAccount < ApplicationRecord
  include Encryption
  attr_encrypted :bank_name, key: encryption_key
  attr_encrypted :bic, key: encryption_key
  attr_encrypted :iban, key: encryption_key

  validates :bank_name, :bic, :iban, presence: true
  validates :iban, bank_iban: true
  validates :bic,  bank_bic: true

  belongs_to :user
end
