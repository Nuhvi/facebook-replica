FactoryBot.define do
  factory :notification do
    association :user
    seen { false }
    notifiable { FactoryBot.build(%i[post comment like].sample) }

    trait :for_post do
      notifiable { FactoryBot.build(:post) }
    end

    trait :for_comment do
      notifiable { FactoryBot.build(:comment) }
    end

    trait :for_like do
      notifiable { FactoryBot.build(:like) }
    end

    trait :seen do
      seen { true }
    end
  end
end
