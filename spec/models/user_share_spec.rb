require 'rails_helper'

RSpec.describe UserShare, type: :model do
  let(:user) { create(:user) }
  let(:share) { create(:share) }
  it 'is valid with valid attributes' do
    expect(UserShare.new(user: user, share: share, date: Date.today, quantity: 1)).to be_valid
  end
  it 'is not valid without user' do
    expect(UserShare.new(user: nil, share: share, date: Date.today, quantity: 1)).not_to be_valid
  end
  it 'is not valid without share' do
    expect(UserShare.new(user: user, share: nil, date: Date.today, quantity: 1)).not_to be_valid
  end
  it 'is not valid without date' do
    expect(UserShare.new(user: user, share: share, date: nil, quantity: 1)).not_to be_valid
  end
  it 'is not valid without quantity' do
    expect(UserShare.new(user: user, share: share, date: Date.today, quantity: nil)).not_to be_valid
  end
  it 'is not valid with a negative quantity' do
    expect(UserShare.new(user: user, share: share, date: Date.today, quantity: -1)).not_to be_valid
  end
end
