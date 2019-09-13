# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  describe 'associations' do
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:likes) }
    it { should have_many(:friendships) }
  end

  describe 'methods' do
    describe '#friends' do
      let (:user) { FactoryBot.create(:user) }
      let (:friend1) { FactoryBot.create(:friend) }
      let (:friend2) { FactoryBot.create(:friend) }

      before do
        user.friendships.create(friend: friend1, confirmed: true)
        friend2.friendships.create(friend: user, confirmed: true)
      end
      it 'return an array of freiends from all confirmed friendships' do
        expect(user.friends).to match_array([friend2, friend1])
      end
    end
  end
end
