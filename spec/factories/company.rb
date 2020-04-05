# frozen_string_literal: true

FactoryBot.define do
  factory :company do
    sequence(:name, 10) { |n| "Company #{n}" }
  end
end
