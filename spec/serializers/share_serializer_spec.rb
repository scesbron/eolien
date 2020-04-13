# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShareSerializer, type: :serializer do
  let(:share) { build(:share) }
  let(:serializer) { described_class.new(share) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  it 'has an id that matches' do
    expect(subject['id']).to eql(share.id)
  end

  it 'has a name that matches' do
    expect(subject['name']).to eql(share.name)
  end

  it 'has an amount that matches' do
    expect(subject['amount']).to eql(share.amount)
  end
end
