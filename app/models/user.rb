# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_friendship

  # Friendships methods

  def strangers
    User.all - [self] - friends - pending_friends - requested_friends
  end

  # Feed methods

  def feed
    Post.where(user: (friends + [self]))
  end

  # Notifications methods

  def unseen_notifs
    notifications - (@seen_notifs || seen_notifs)
  end

  def seen_notifs
    @seen_notifs ||= []
    @seen_notifs += unseen_notifs.select(&:seen)
  end

  def see_all_notifs
    unseen_notifs.each { |notification| notification.update(seen: true) }
  end

  # callbacks

  def on_friendship_created(friendship)
    notifications.create(notifiable: friendship) unless friendship.status == 'requested'
  end

  def on_friendship_accepted(friendship)
    notifications.create(notifiable: friendship)
  end
end
