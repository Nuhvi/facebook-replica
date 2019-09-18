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
          FactoryBot.create(:friendship,  :accepted, user: user)
          FactoryBot.create(:friendship,  :accepted, user: user)
        end.to change { user.strangers.count }.by(2)
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
