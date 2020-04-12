require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  let(:user) { create(:user) }
  let(:iban) { 'FR7630001007941234567890185' }
  let(:bic) { 'AGRIFRPP' }
  it 'is valid with valid attributes' do
    expect(BankAccount.new(bank_name: 'Banque', bic: bic, iban: iban, user: user)).to be_valid
  end
  it 'is not valid without a name' do
    expect(BankAccount.new(bank_name: nil, bic: bic, iban: iban, user: user)).not_to be_valid
  end
  it 'is not valid without a bic' do
    expect(BankAccount.new(bank_name: 'Banque', bic: nil, iban: iban, user: user)).not_to be_valid
  end
  it 'is not valid without an invalid bic' do
    expect(BankAccount.new(bank_name: 'Banque', bic: 't', iban: iban, user: user)).not_to be_valid
  end
  it 'is not valid without an invalid iban' do
    expect(BankAccount.new(bank_name: 'Banque', bic: bic, iban: '1234', user: user)).not_to be_valid
  end
  it 'is not valid without a user' do
    expect(BankAccount.new(bank_name: 'Banque', bic: bic, iban: iban, user: nil)).not_to be_valid
  end
end
