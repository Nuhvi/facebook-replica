# frozen_string_literal: true

class Notification < ApplicationRecord
  validates :user, presence: true
  validates :notifiable, presence: true

  belongs_to :notifiable, polymorphic: true
  belongs_to :user

  default_scope { order(created_at: :desc) }

  def notifier
    return notifiable.friendable if notifiable_type == 'HasFriendship::Friendship'

    notifiable.user
  end
end
