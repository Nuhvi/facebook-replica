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

  let(:user) { FactoryBot.create(:user) }
  let(:friend1) { FactoryBot.create(:friend) }
  let(:friend2) { FactoryBot.create(:friend) }
  let(:friend3) { FactoryBot.create(:friend) }

  describe 'methods' do
    describe '#strangers' do
      it 'return all non friends' do
        expect do
          FactoryBot.create(:friendship, :accepted, user: user)
          FactoryBot.create(:friendship, :accepted, user: user)
        end.to change { user.strangers.count }.by(2)
      end
    end

    describe '#friend_request(friend)' do
      it 'create two friendships with status 0 and 1 for user and friend respectively' do
        user.friend_request(friend1)
        expect(user.friendships.first.status).to eq(0)
        expect(friend1.friendships.first.status).to eq(1)
      end
    end

    describe '#accept_request(friend)' do
      it 'updates the two rows of a friendship to status: 2' do
        user.friend_request(friend1)
        friend1.accept_request(user)
        expect(user.friendships.first.status).to eq(2)
        expect(friend1.friendships.first.status).to eq(2)
      end
    end

    describe '#friends_with?(friend)' do
      it 'returns if the user has accepted that friendship' do
        user.friend_request(friend1)
        friend1.accept_request(user)
        friend2.friend_request(user)
        expect(user.friends_with?(friend1)).to be true
        expect(user.friends_with?(friend2)).to be false
        expect(user.friends_with?(friend3)).to be false
      end
    end

    describe '#decline_request, #remove_friend' do
      it 'removes the two rows of friendship' do
        user.friend_request(friend1)
        friend1.accept_request(user)
        friend1.remove_friend(user)
        expect(user.friends_with?(friend1)).to be false
        expect(user.friends_with?(friend2)).to be false
        expect(user.method(:decline_request)).to eq(user.method(:remove_friend))
      end
    end

    # notifications methods

    before do
      2.times { FactoryBot.create(:notification, user: user) }
      3.times { FactoryBot.create(:notification, :seen, user: user) }
    end

    describe '#unseen' do
      it 'sets all unseen notifications to seen' do
        expect(user.unseen_notifs.count).to eq(2)
      end
    end

    describe '#seen' do
      it 'returns all  seen notifications' do
        expect(user.seen_notifs.count).to eq(3)
      end
    end

    describe '#set_to_seen' do
      it 'sets all unseen notifications to seen' do
        user.see_all_notifs
        expect(user.seen_notifs.count).to eq(5)
      end
    end
  end
end
