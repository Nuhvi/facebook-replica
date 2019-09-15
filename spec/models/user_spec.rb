# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:posts) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:likes) }
    it { is_expected.to have_many(:friendships) }
    it { is_expected.to have_many(:notifications) }
  end

  describe 'methods' do
    let(:user) { FactoryBot.create(:user) }
    let(:friend1) { FactoryBot.create(:friend) }
    let(:friend2) { FactoryBot.create(:friend) }

    describe '#friends' do
      before do
        user.friendships.create(friend: friend1, confirmed: true)
        friend2.friendships.create(friend: user, confirmed: true)
      end
      it 'return an array of freiends from all confirmed friendships' do
        expect(user.friends).to match_array([friend2, friend1])
      end
    end

    describe '#pending_friends' do
      before do
        user.friendships.create(friend: friend1)
        user.friendships.create(friend: friend2)
      end
      it 'return an array of all pending friends' do
        expect(user.pending_friends).to match_array([friend2, friend1])
      end
    end

    describe '#friend_requests' do
      before do
        friend1.friendships.create(friend: user)
        friend2.friendships.create(friend: user)
      end
      it 'return an array of all friends requests users' do
        expect(user.friend_requests).to match_array([friend2, friend1])
      end
    end

    describe '#confirm_friend(user)' do
      before do
        friend1.friendships.create(friend: user)
        user.confirm_friend(friend1)
      end

      it 'confirms friend request' do
        expect(friend1.friendships.find_by(friend: user).confirmed).to be true
      end
    end

    describe '#friend?(user)' do
      before do
        friend1.friendships.create(friend: user, confirmed: true)
        friend2.friendships.create(friend: user)
      end
      it 'return whether a user is a confirmed friend' do
        expect(user.friend?(friend1)).to be true
        expect(user.friend?(friend2)).to be false
      end
    end
  end
end
