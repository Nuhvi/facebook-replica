# frozen_string_literal: true

class Friendship < ApplicationRecord
  validates :user, presence: true
  validates :friend, presence: true
  validate :not_friending_self
  validate :not_already_exist, on: :create

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  class << self
    def find_for_both(user1_id, user2_id)
      (Friendship.where(user_id: user1_id, friend_id: user2_id) +
       Friendship.where(user_id: user2_id, friend_id: user1_id)).first
    end
  end

  private

  def not_already_exist
    errors.add(:unique_friendship, 'Friendship already exist!') if Friendship.find_for_both(user_id, friend_id)
  end

  def not_friending_self
    errors.add(:invalid_self_friendship, 'One can\'t friend oneself') if user == friend
  end
end
