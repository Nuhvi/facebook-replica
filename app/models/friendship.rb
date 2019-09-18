# frozen_string_literal: true

class Friendship < ApplicationRecord
  validates :user, presence: true
  validates :friend, presence: true
  validates_inclusion_of :status, in: [0, 1, 2]
  validate :not_friending_self
  validate :not_already_exist, on: :create

  default_scope { order(created_at: :desc) }

  belongs_to :user
  belongs_to :friend, class_name: 'User'
  has_one :notification, as: :notifiable, dependent: :destroy

  private

  def find_relation(user, friend)
    Friendship.where(user: user, friend: friend)
  end

  def not_already_exist
    errors.add(:unique_friendship, 'Friendship already exist!') if find_relation(user, friend).any? || find_relation(friend, user).any?
  end

  def not_friending_self
    errors.add(:invalid_self_friendship, 'One can\'t friend oneself') if user == friend
  end
end
