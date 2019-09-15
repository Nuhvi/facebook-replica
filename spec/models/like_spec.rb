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
    context 'after creation' do
      let(:user) { FactoryBot.create(:user) }
      let(:other_user) { FactoryBot.create(:user) }
      let(:post) { FactoryBot.create(:post, user: user) }
      context 'liking your own post' do
        it 'will create a notification after liking the post' do
          expect do
            post.likes.create(user: user)
          end.not_to change(post.user.notifications, :count)
        end
      end
      context 'other user liking your post' do
        it 'will create a notification after liking the post' do
          expect do
            post.likes.create(user: other_user)
          end.to change(post.user.notifications, :count).by(1)
        end
      end
    end
  end
end
