# frozen_string_literal: true

FactoryBot.define do
  factory :loan do
    sequence(:name, 10) { |n| "Loan #{n}" }
    amount { 200 }
  end
end
