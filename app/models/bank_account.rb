class BankAccount < ApplicationRecord
  attr_encrypted :bank_name, key: '38aa859ab0d7e6d93f1cbfbcb3afdf98'
  attr_encrypted :bic, key: '38aa859ab0d7e6d93f1cbfbcb3afdf98'
  attr_encrypted :iban, key: '38aa859ab0d7e6d93f1cbfbcb3afdf98'

  validates :bank_name, :bic, :iban, presence: true
  validates :iban, bank_iban: true
  validates :bic,  bank_bic: true

  belongs_to :user
end
