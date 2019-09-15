# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:post)).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:likes) }
    it { is_expected.to have_many(:notifications) }
  end

  describe 'default scope' do
    let!(:post_one) { FactoryBot.create(:post) }
    let!(:post_two) { FactoryBot.create(:post) }
    let!(:post_three) { FactoryBot.create(:post) }

    it 'orders posts in update chronological order' do
      expect(Post.all).to eq [post_three, post_two, post_one]
    end
  end

  describe 'methods' do
  end
end
