class Friendship < ApplicationRecord
  validates :user, presence: true
  validates :friend, presence: true
  validate :not_friending_self
  validate :not_already_exist

  belongs_to :user
  belongs_to :friend, :class_name => "User"

  private

  def not_already_exist
    if (Friendship.where(user_id: user_id, friend_id: friend_id).exists? || Friendship.where(user_id: friend_id, friend_id: user_id).exists?)
      errors.add(:unique_friendship, 'Friendship already exist!')
    end
  end 

  def not_friending_self
    if user == friend
      errors.add(:invalid_self_friendship, 'One can\'t friend oneself')
    end
  end
end
