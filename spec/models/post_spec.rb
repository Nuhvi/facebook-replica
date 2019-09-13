# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:post)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:comments) }
    it { should have_many(:likes) }
  end

  describe 'default scope' do
    let!(:post_one) { FactoryBot.create(:post) }
    let!(:post_two) { FactoryBot.create(:post) }
    let!(:post_three) { FactoryBot.create(:post) }
    before { post_two.update(content: 'updated') }

    it 'orders posts in update chronological order' do
      Post.all.should eq [post_two, post_three, post_one]
    end
  end

  describe 'methods' do
  end
end
