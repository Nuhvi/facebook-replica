FactoryBot.define do
  factory :like do
    user { nil }
    likeable { nil }
    content { "MyText" }
  end
end
