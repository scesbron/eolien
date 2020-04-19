# frozen_string_literal: true

FactoryBot.define do
  factory :company do
    sequence(:name, 10) { |n| "Company #{n}" }
    sequence(:slug, 10) { |n| "company_#{n}" }
    wind_farm
  end
end
