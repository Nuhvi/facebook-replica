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

  after_create :create_request
  after_create :notify_requested
  after_update :notify_requester

  # methods

  def exists?(user, friend)
    find_relation(user, friend) || find_relation(friend, user)
  end

  private

  def find_relation(user, friend)
    Friendship.where(user: user, friend: friend).first
  end

  def sender?
    status.zero?
  end

  # validations

  def not_already_exist
    errors.add(:unique_friendship, 'Friendship already exist!') if find_relation(user, friend)
  end

  def not_friending_self
    errors.add(:invalid_self_friendship, 'One can\'t friend oneself') if user == friend
  end

  # callbacks

  def create_request
    friend.friendships.create(friend: user, status: 1) if sender?
  end

  def notify_requested
    friend.notifications.create(notifiable: self) if sender?
  end

  def notify_requester
    friend.notifications.create(notifiable: self) unless status_before_last_save.zero?
  end
end
