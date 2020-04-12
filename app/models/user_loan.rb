class UserLoan < ApplicationRecord
  validates :date, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  belongs_to :loan
  belongs_to :user
end
