# frozen_string_literal: true

FactoryBot.define do
  factory :wind_farm do
    sequence(:name, 10) { |n| "Wind farm #{n}" }
    sequence(:slug, 10) { |n| "wind_farm_#{n}" }
  end
end
