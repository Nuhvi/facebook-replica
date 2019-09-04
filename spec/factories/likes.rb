FactoryBot.define do
  factory :like do
    user { FactoryBot.build(:user) }
    likeable { FactoryBot.build(:post) }
  
  end
end
