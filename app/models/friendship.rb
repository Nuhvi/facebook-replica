# frozen_string_literal: true

class Friendship < ApplicationRecord
  validates :user, presence: true
  validates :friend, presence: true
  validates_inclusion_of :status, in: [0, 1, 2]

  default_scope { order(created_at: :desc) }

  belongs_to :user
  belongs_to :friend, class_name: 'User'
  has_one :notification, as: :notifiable, dependent: :destroy
end
