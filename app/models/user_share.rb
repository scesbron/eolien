class UserShare < ApplicationRecord
  validates :date, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  belongs_to :share
  belongs_to :user
end
