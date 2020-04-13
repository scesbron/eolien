# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoanSerializer, type: :serializer do
  let(:loan) { build(:loan) }
  let(:serializer) { described_class.new(loan) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  it 'has an id that matches' do
    expect(subject['id']).to eql(loan.id)
  end

  it 'has a name that matches' do
    expect(subject['name']).to eql(loan.name)
  end

  it 'has an amount that matches' do
    expect(subject['amount']).to eql(loan.amount)
  end
end
