# frozen_string_literal: true

FactoryBot.define do
  factory :like do
    user { FactoryBot.build(:user) }
    likeable { FactoryBot.build(%i[post comment].sample) }
  end
end
