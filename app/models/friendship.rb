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

  private

  # validations

  def not_already_exist
    return if Friendship.where(user: user, friend: friend).empty?

    errors.add(:unique_friendship, 'Friendship already exist!')
  end

  def not_friending_self
    errors.add(:invalid_self_friendship, 'One can\'t friend oneself!') if user == friend
  end

  # callbacks
  def sender?
    status.zero?
  end

  def create_request
    friend.friendships.create(friend: user, status: 1) if sender?
  end

  def notify_requested
    create_notification(user: friend) if sender?
  end

  def notify_requester
    if status_before_last_save.zero? # if the notification was a sent request
      Notification.find_by(notifiable: self).destroy # find old notification and delete it
    else 
      create_notification(user: friend)
    end
  end
end
