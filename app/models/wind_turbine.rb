class WindTurbine < ApplicationRecord
  validates :name, :reference, presence: true
  belongs_to :wind_farm

  scope :enabled, -> { where(enabled: true) }
end
