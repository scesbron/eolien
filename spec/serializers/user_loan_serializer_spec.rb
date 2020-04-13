# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserLoanSerializer, type: :serializer do
  let(:loan) { UserLoan.new(loan: build(:loan), user: build(:user), date: Date.new(2020, 4, 20), quantity: 2) }
  let(:serializer) { described_class.new(loan) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  it 'has an id that matches' do
    expect(subject['id']).to eql(loan.id)
  end

  it 'has a quantity that matches' do
    expect(subject['quantity']).to eql(loan.quantity)
  end

  it 'has an date that matches' do
    expect(subject['date']).to eql('2020-04-20')
  end

  it 'has the loan informations' do
    expect(subject['loan']).not_to be_nil
  end

  it 'does not have user information' do
    expect(subject['user_id']).to be_nil
    expect(subject['user']).to be_nil
  end
end
