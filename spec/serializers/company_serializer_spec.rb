# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanySerializer, type: :serializer do
  let(:company) { build(:company, email: 'contact@company.com', phone: '01 02 03 04 05', legal_name: 'Big company', legal_agent: 'Mr President') }
  let(:serializer) { described_class.new(company) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  it 'has an id that matches' do
    expect(subject['id']).to eql(company.id)
  end

  it 'has a name that matches' do
    expect(subject['name']).to eql(company.name)
  end

  it 'has an email that matches' do
    expect(subject['email']).to eql(company.email)
  end

  it 'has a phone that matches' do
    expect(subject['phone']).to eql(company.phone)
  end

  it 'has a legal name that matches' do
    expect(subject['legalName']).to eql(company.legal_name)
  end

  it 'has a legal agent that matches' do
    expect(subject['legalAgent']).to eql(company.legal_agent)
  end
end
