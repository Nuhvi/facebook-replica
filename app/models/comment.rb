# frozen_string_literal: true

class Comment < ApplicationRecord
  validates :content, presence: true

  belongs_to :user
  belongs_to :post
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  default_scope { order(created_at: :desc) }

  after_create :create_notification

  def create_notification
    notifications.create(user: post.user) unless user == post.user
  end
end
