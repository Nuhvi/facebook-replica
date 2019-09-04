require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:comment)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'associations' do
    it { should belong_to(:post) }
    it { should belong_to(:user) }
    it { should have_many(:likes) } 

  end

  describe 'default scope' do
    let!(:comment_one) { FactoryBot.create(:comment) }
    let!(:comment_two) { FactoryBot.create(:comment) }
    let!(:comment_three) { FactoryBot.create(:comment) }
    before { comment_two.update(content: 'updated') }

    it 'orders comments in update chronological order' do
      Comment.all.should eq [comment_two, comment_three, comment_one]
    end
  end

  describe 'methods' do
  end
end
