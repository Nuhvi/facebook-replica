# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    content { 'MyString' }
    user { FactoryBot.build(:user) }

    trait :invalid do
      content { '' }
    end
  end
end
