FactoryBot.define do
  factory :comment do
    content { "MyText" }
    user { FactoryBot.build(:user) }    
    post { FactoryBot.build(:post) }

    trait :invalid do
      content { '' }
    end
  end
end
