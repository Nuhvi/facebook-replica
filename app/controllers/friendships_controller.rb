class FriendshipsController < ApplicationController
  def index
  end

  def create
    current_user.friendships.create(friend_id: 2)
  end

  def destroy
  end
end
