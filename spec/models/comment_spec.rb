# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:comment)).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:likes) }
    it { is_expected.to have_many(:notifications) }
  end

  describe 'default scope' do
    let!(:comment_one) { FactoryBot.create(:comment) }
    let!(:comment_two) { FactoryBot.create(:comment) }
    let!(:comment_three) { FactoryBot.create(:comment) }

    it 'orders comments in update chronological order' do
      expect(Comment.all).to eq [comment_three, comment_two, comment_one]
    end
  end

  describe 'methods' do
  end
end
