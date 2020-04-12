class Productible < ApplicationRecord
  validates :name, presence: true
  validates :month, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
