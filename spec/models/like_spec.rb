# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:like)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:likeable) }
    it { is_expected.to have_many(:notifications) }
  end

  describe 'methods' do
  end

  describe 'callbacks' do
    describe '#create_notification' do
      it 'will create a notification after creating a like' do
        user = FactoryBot.create(:user)
        post = FactoryBot.create(:post)
        expect do
          post.likes.create(user: user)
        end.to change(post.user.notifications, :count).by(1)
      end
    end
  end
end
