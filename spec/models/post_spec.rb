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
  end

  describe 'methods' do
  end
end
