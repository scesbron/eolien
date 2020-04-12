require 'rails_helper'

RSpec.describe Share, type: :model do
  it 'is valid with valid attributes' do
    expect(Share.new(name: 'Action', amount: 200)).to be_valid
  end
  it 'is not valid without a name' do
    expect(Share.new(name: nil, amount: 200)).to_not be_valid
  end
  it 'is not valid without an amount' do
    expect(Share.new(name: 'Action', amount: nil)).to_not be_valid
  end
  it 'is not valid with a negative amount' do
    expect(Share.new(name: 'Action', amount: -1)).to_not be_valid
  end
end
