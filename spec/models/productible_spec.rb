require 'rails_helper'

RSpec.describe Productible, type: :model do
  it 'is valid with valid attributes' do
    expect(Productible.new(name: 'P90', month: 1, value: 10.1)).to be_valid
  end
  it 'is not valid without a name' do
    expect(Productible.new(name: nil, month: 1, value: 10.1)).to_not be_valid
  end
  it 'is not valid without a month' do
    expect(Productible.new(name: 'P90', month: nil, value: 10.1)).to_not be_valid
  end
  it 'is not valid with a month lower than 1' do
    expect(Productible.new(name: 'P90', month: 0, value: 10.1)).to_not be_valid
  end
  it 'is not valid with a month greater than 12' do
    expect(Productible.new(name: 'P90', month: 13, value: 10.1)).to_not be_valid
  end
  it 'is not valid without a value' do
    expect(Productible.new(name: 'P90', month: 1, value: nil)).to_not be_valid
  end
  it 'is not valid with a negative value' do
    expect(Productible.new(name: 'P90', month: 1, value: -1)).to_not be_valid
  end
end
