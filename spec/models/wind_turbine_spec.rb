require 'rails_helper'

RSpec.describe WindTurbine, type: :model do
  it 'is valid with valid attributes' do
    expect(WindTurbine.new(name: 'Eolienne 5', reference: 'eo5')).to be_valid
  end
  it 'is not valid without a name' do
    expect(WindTurbine.new(name: nil, reference: 'eo5')).not_to be_valid
  end
  it 'is not valid without a reference' do
    expect(WindTurbine.new(name: 'Eolienne 5', reference: nil)).not_to be_valid
  end
end
