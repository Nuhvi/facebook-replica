# frozen_string_literal: true

FactoryBot.define do
  factory :friendship do
    association :user
    association :friend

    trait :confirmed do
      confirmed { true }
    end
  end
end
