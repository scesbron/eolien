require 'rails_helper'

RSpec.describe Loan, type: :model do
  it 'is valid with valid attributes' do
    expect(Loan.new(name: 'CCA', amount: 200)).to be_valid
  end
  it 'is not valid without a name' do
    expect(Loan.new(name: nil, amount: 200)).to_not be_valid
  end
  it 'is not valid without an amount' do
    expect(Loan.new(name: 'CCA', amount: nil)).to_not be_valid
  end
  it 'is not valid with a negative amount' do
    expect(Loan.new(name: 'CCA', amount: -1)).to_not be_valid
  end
end
