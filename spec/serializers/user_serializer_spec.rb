# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  let(:user) do
    user = build(:user, phone: '01 02 03 04 05', birth_date: Date.new(2000, 11, 30))
    user.shares = [UserShare.new(share: build(:share, company: user.company), user: user, date: Date.today, quantity: 2)]
    user.loans = [UserLoan.new(loan: build(:loan, company: user.company), user: user, date: Date.today, quantity: 2)]
    user
  end
  let(:serializer) { described_class.new(user) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  it 'has an id that matches' do
    expect(subject['id']).to eql(user.id)
  end

  it 'has a username that matches' do
    expect(subject['username']).to eql(user.username)
  end

  it 'has an email that matches' do
    expect(subject['email']).to eql(user.email)
  end

  it 'has a phone that matches' do
    expect(subject['phone']).to eql(user.phone)
  end

  it 'has a birth date that matches' do
    expect(subject['birthDate']).to eql('2000-11-30')
  end

  it 'has loans data' do
    expect(subject['loans'].size).to eql(1)
    expect(subject['loans'][0]['quantity']).to eql(user.loans.first.quantity)
    expect(subject['loans'][0]['loan']['name']).to eql(user.loans.first.loan.name)
  end

  it 'has shares data' do
    expect(subject['shares'].size).to eql(1)
  end
end
