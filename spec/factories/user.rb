# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email, 10) { |n| "tester#{n}@test.com" }
    sequence(:username, 10) { |n| "user#{n}" }
    password { 'Helloworld123' }
    firstname { 'John' }
    lastname { 'Doe' }
    company
  end
end
