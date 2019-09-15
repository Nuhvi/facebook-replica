# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:notification)).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:notifiable) }
  end

  describe 'default scope' do
    let!(:notification_one) { FactoryBot.create(:notification) }
    let!(:notification_two) { FactoryBot.create(:notification) }
    let!(:notification_three) { FactoryBot.create(:notification) }

    it 'orders notifications in update chronological order' do
      expect(Notification.all).to eq [notification_three, notification_two, notification_one]
    end
  end

  describe 'methods' do
  end
end
