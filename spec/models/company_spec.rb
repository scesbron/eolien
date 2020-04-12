require 'rails_helper'

RSpec.describe Company, type: :model do
  it 'is valid with valid attributes' do
    expect(Company.new(name: 'EoLien')).to be_valid
  end
  it 'is not valid without a name' do
    expect(Company.new(name: nil)).to_not be_valid
  end
end
