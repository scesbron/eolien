require 'rails_helper'

RSpec.describe Loan, type: :model do
  let(:company) { create(:company) }
  it 'is valid with valid attributes' do
    expect(Loan.new(name: 'CCA', amount: 200, company: company)).to be_valid
  end
  it 'is not valid without a name' do
    expect(Loan.new(name: nil, amount: 200, company: company)).to_not be_valid
  end
  it 'is not valid without an amount' do
    expect(Loan.new(name: 'CCA', amount: nil, company: company)).to_not be_valid
  end
  it 'is not valid with a negative amount' do
    expect(Loan.new(name: 'CCA', amount: -1, company: company)).to_not be_valid
  end
  it 'is not valid without an amount' do
    expect(Loan.new(name: 'CCA', amount: nil, company: company)).to_not be_valid
  end
end
