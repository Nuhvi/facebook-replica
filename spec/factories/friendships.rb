# frozen_string_literal: true

FactoryBot.define do
  factory :friendship do
    association :user
    association :friend
    status { 0 }

    trait :requested do
      status { 1 }
    end
    trait :accepted do
      status { 2 }
    end
  end
end
