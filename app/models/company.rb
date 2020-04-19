class Company < ApplicationRecord
  validates :name, :slug, presence: true
  belongs_to :wind_farm
  has_many :users
end
