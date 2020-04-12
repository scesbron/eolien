require 'rails_helper'

RSpec.describe User, type: :model do
  let(:company) { create(:company) }
  it 'is valid with valid attributes' do
    expect(User.new(firstname: 'John', lastname: 'Doe', email: 'john@doe.com', username: 'jdoe', company: company, password: 'password')).to be_valid
  end
  it 'is not valid without a firstname' do
    expect(User.new(firstname: nil, lastname: 'Doe', email: 'john@doe.com', username: 'jdoe', company: company, password: 'password')).not_to be_valid
  end
  it 'is not valid without a lastname' do
    expect(User.new(firstname: 'John', lastname: nil, email: 'john@doe.com', username: 'jdoe', company: company, password: 'password')).not_to be_valid
  end
  it 'is not valid without a email' do
    expect(User.new(firstname: 'John', lastname: 'Doe', email: nil, username: 'jdoe', company: company, password: 'password')).not_to be_valid
  end
  it 'is not valid without a username' do
    expect(User.new(firstname: 'John', lastname: 'Doe', email: 'john@doe.com', username: nil, company: company, password: 'password')).not_to be_valid
  end
  it 'is not valid without a company' do
    expect(User.new(firstname: 'John', lastname: 'Doe', email: 'john@doe.com', username: 'jdoe', company: nil, password: 'password')).not_to be_valid
  end
  it 'is not valid without a password' do
    expect(User.new(firstname: 'John', lastname: 'Doe', email: 'john@doe.com', username: 'jdoe', company: company, password: nil)).not_to be_valid
  end
end
