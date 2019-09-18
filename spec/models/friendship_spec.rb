# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:friend) { FactoryBot.build(:friend) }

  it 'has a valid factory' do
    expect(FactoryBot.build(:friendship)).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:friend) }
    it { is_expected.to validate_inclusion_of(:status).in_array([0, 1, 2]) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:friend) }
    it { is_expected.to have_one(:notification).dependent(:destroy) }
  end

  describe 'methods' do
  end
end
