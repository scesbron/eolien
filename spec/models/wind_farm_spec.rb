require 'rails_helper'

RSpec.describe Company, type: :model do
  it 'is valid with valid attributes' do
    expect(Company.new(name: 'EoLien', slug: 'eolien')).to be_valid
  end
  it 'is not valid without a name' do
    expect(Company.new(name: nil, slug: 'eolien')).to_not be_valid
  end
  it 'is not valid without a slug' do
    expect(Company.new(name: 'EoLien', slug: nil)).to_not be_valid
  end
end
