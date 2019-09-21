# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true
  has_many :notifications, as: :notifiable, dependent: :destroy

  after_create :create_notification

  def create_notification
    notifications.create(user: likeable.user) unless user == likeable.user
  end
end
