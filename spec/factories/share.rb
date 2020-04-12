# frozen_string_literal: true

FactoryBot.define do
  factory :share do
    sequence(:name, 10) { |n| "Share #{n}" }
    amount { 200 }
  end
end
