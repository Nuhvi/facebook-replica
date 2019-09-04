require 'rails_helper'

RSpec.describe Like, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:like)).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:likeable) }
  end

  describe 'methods' do
  end
end
