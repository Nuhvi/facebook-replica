# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:friend) { FactoryBot.build(:friend) }

  it 'has a valid factory' do
    expect(FactoryBot.build(:friendship)).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:friend) }
    it 'validate that users are not trying to friend themselves' do
      friendship = FactoryBot.build(:friendship, user: user, friend: user)
      expect(friendship).to be_invalid
      expect(friendship.errors[:invalid_self_friendship]).to include('One can\'t friend oneself')
    end
    it 'validate the uniquness of user-friend pair' do
      FactoryBot.create(:friendship, user: user, friend: friend)
      friendship = FactoryBot.build(:friendship, user: user, friend: friend)
      expect(friendship).to be_invalid
      expect(friendship.errors[:unique_friendship]).to include('Friendship already exist!')
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:friend) }
    it { is_expected.to have_many(:notifications) }
  end

  describe 'methods' do
    describe '#find_for_both(user1_id, user2_id)' do
      it 'returns any friendship with both users in any combintaion' do
        friendship = FactoryBot.create(:friendship, user: user, friend: friend)
        expect(Friendship.find_for_both(user.id, friend.id)).to eq(friendship)
      end
    end
  end

  describe 'callbacks' do
    let(:user) { FactoryBot.create(:user) }
    let(:friend) { FactoryBot.create(:friend) }
    context 'after creation' do
      describe '#create_notification' do
        it 'will create a notification after creating a friend request' do
          expect do
            user.friendships.create(friend: friend)
          end.to change(friend.notifications, :count).by(1)
        end
      end
    end

    context 'after update' do
      describe '#update_notification' do
        it 'will create a notification after accepting a friend request' do
          user.friendships.create(friend: friend)
          expect do
            friend.confirm_friend(user)
          end.to change(user.notifications, :count).by(1)
        end
      end
    end
  end
end
