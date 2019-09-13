FactoryBot.define do
  factory :friendship do
    association :user
    association :friend
    confirmed { false }

    trait :confirmed do
      confirmed { true }
    end
  end
end
