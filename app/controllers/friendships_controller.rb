# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  # all friends
  def index
    case params[:format]
    when 'requests_received' then @friends = @user.friend_requests
                                  @title = 'Received requests'
    when 'requests_sent' then @friends = @user.pending_friends
                              @title = 'Sent requests'
    else @friends = @user.friends
         @title = 'Friends'
    end
  end

  # create request
  def create
    friend_request = current_user.friendships.build(friend_id: params[:user_id])
    flash[:notice] = "Friend request submitted to #{@user.first_name}" if friend_request.save
    redirect_back(fallback_location: root_path)
  end

  # accept requests
  def update
    current_user.confirm_friend(@user)
    redirect_back(fallback_location: root_path)
  end

  # unfriend / delete request / reject request
  def destroy
    friendship = Friendship.find_for_both(current_user.id, @user.id)

    if friendship
      friendship.destroy
      user_name = @user.first_name

      flash[:notice] = case params[:format]
                       when 'reject_request' then "Rejected request from #{user_name}"
                       when 'cancel_request' then "Canceled request to #{user_name}"
                       else "UnFriended #{user_name}"
                       end
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
