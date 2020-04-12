require 'rails_helper'

RSpec.describe UserLoan, type: :model do
  let(:user) { create(:user) }
  let(:loan) { create(:loan) }
  it 'is valid with valid attributes' do
    expect(UserLoan.new(user: user, loan: loan, date: Date.today, quantity: 1)).to be_valid
  end
  it 'is not valid without user' do
    expect(UserLoan.new(user: nil, loan: loan, date: Date.today, quantity: 1)).not_to be_valid
  end
  it 'is not valid without loan' do
    expect(UserLoan.new(user: user, loan: nil, date: Date.today, quantity: 1)).not_to be_valid
  end
  it 'is not valid without date' do
    expect(UserLoan.new(user: user, loan: loan, date: nil, quantity: 1)).not_to be_valid
  end
  it 'is not valid without quantity' do
    expect(UserLoan.new(user: user, loan: loan, date: Date.today, quantity: nil)).not_to be_valid
  end
  it 'is not valid with a negative quantity' do
    expect(UserLoan.new(user: user, loan: loan, date: Date.today, quantity: -1)).not_to be_valid
  end
end
