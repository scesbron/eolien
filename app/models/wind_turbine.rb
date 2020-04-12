class WindTurbine < ApplicationRecord
  validates :name, :reference, presence: true
end
