# frozen_string_literal: true

FactoryBot.define do
  factory :wind_turbine do
    sequence(:name, 1) { |n| "Eolienne #{n}" }
    sequence(:reference, 1) { |n| "EO#{n}" }
  end
end
