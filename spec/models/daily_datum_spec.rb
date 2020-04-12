require 'rails_helper'

RSpec.describe DailyDatum, type: :model do
  let(:turbine) { create(:wind_turbine) }
  it 'is valid with valid attributes' do
    expect(DailyDatum.new(day: Date.today, wind_turbine: turbine, production: 100, consumption: 0, disponibility: 95.5, wind_speed: 10.1)).to be_valid
  end
  it 'is not valid without day' do
    expect(DailyDatum.new(day: nil, wind_turbine: turbine, production: 100, consumption: 0, disponibility: 95.5, wind_speed: 10.1)).not_to be_valid
  end
  it 'is not valid without turbine' do
    expect(DailyDatum.new(day: Date.today, wind_turbine: nil, production: 100, consumption: 0, disponibility: 95.5, wind_speed: 10.1)).not_to be_valid
  end
  it 'is not valid without production' do
    expect(DailyDatum.new(day: Date.today, wind_turbine: turbine, production: nil, consumption: 0, disponibility: 95.5, wind_speed: 10.1)).not_to be_valid
  end
  it 'is not valid without consumption' do
    expect(DailyDatum.new(day: Date.today, wind_turbine: turbine, production: 100, consumption: nil, disponibility: 95.5, wind_speed: 10.1)).not_to be_valid
  end
  it 'is not valid without disponibility' do
    expect(DailyDatum.new(day: Date.today, wind_turbine: turbine, production: 100, consumption: 0, disponibility: nil, wind_speed: 10.1)).not_to be_valid
  end
  it 'is not valid without wind speed' do
    expect(DailyDatum.new(day: Date.today, wind_turbine: turbine, production: 100, consumption: 0, disponibility: 95.5, wind_speed: nil)).not_to be_valid
  end
end
