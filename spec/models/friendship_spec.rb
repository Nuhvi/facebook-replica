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
    it { is_expected.to validate_inclusion_of(:status).in_array([0, 1, 2]) }
    it 'validate that users are not trying to friend themselves' do
      friendship = FactoryBot.build(:friendship, user: user, friend: user)
      expect(friendship).to be_invalid
    end
    it 'validate the user - friend relation doesnt already exist' do
      FactoryBot.create(:friendship, user: user, friend: friend)
      friendship = FactoryBot.build(:friendship, user: user, friend: friend)
      expect(friendship).to be_invalid
    end
  end

  describe 'default scope' do
    let!(:friendship_one) { FactoryBot.create(:friendship, :accepted, user: user) }
    let!(:friendship_two) { FactoryBot.create(:friendship, :accepted, user: user) }
    let!(:friendship_three) { FactoryBot.create(:friendship, :accepted, user: user) }

    it 'orders comments in update chronological order' do
      expect(user.friendships).to eq [friendship_three, friendship_two, friendship_one]
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:friend) }
    it { is_expected.to have_one(:notification).dependent(:destroy) }
  end

  describe 'methods' do
  end

  describe 'callbacks' do
    context 'send a friend request to someone' do
      it 'creates another friendship for that user with status: 1' do
        FactoryBot.create(:friendship, user: user, friend: friend)
        expect(Friendship.where(user: user, friend: friend).first.status).to eq(0)
        expect(Friendship.where(user: friend, friend: user).first.status).to eq(1)
      end

      it 'create a notification for requested' do
        FactoryBot.create(:friendship, user: user, friend: friend)
        expect(friend.notifications.last.notifiable.user).to eq(user)
        expect(user.notifications.empty?).to be true
      end
    end

    context 'accept a friend request' do
      before do
        FactoryBot.create(:friendship, user: user, friend: friend)
        Friendship.all.each { |f| f.update(status: 2) }
      end

      it 'create a notification for the requester' do
        expect(user.notifications.count).to eq(1)
        expect(user.notifications.last.notifiable.user).to eq(friend)
        expect(user.notifications.last.notifiable.status).to eq(2)
      end

      it 'delete the old notification for the requested' do
        expect(friend.notifications.count).to eq(0)
      end
    end
  end
end
