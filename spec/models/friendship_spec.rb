# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:friend) { FactoryBot.build(:friend) }

  it 'has a valid factory' do
    expect(FactoryBot.build(:friendship)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:friend) }
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
    it { should belong_to(:user) }
    it { should belong_to(:friend) }
  end

  describe 'methods' do
    describe '#find_for_both(user1_id, user2_id)' do
      it 'returns any friendship with both users in any combintaion' do
        friendship = FactoryBot.create(:friendship, user: user, friend: friend)
        expect(Friendship.find_for_both(user.id, friend.id)).to eq(friendship)
      end
    end
  end
end
