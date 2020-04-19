class WindFarm < ApplicationRecord
  validates :name, :slug, presence: true
  has_many :companies
  has_many :wind_turbines
end
