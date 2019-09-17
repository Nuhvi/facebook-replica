# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  # all friends
  def index
    case params[:format]
    when 'requests_received' then @friends = @user.requested_friends.reverse
                                  @title = 'Received requests'
    when 'requests_sent' then @friends = @user.pending_friends.reverse
                              @title = 'Sent requests'
    else @friends = @user.friends.reverse
         @title = 'Friends'
    end
  end

  # create request
  def create
    friend_request = current_user.friend_request(User.find(params[:user_id]))
    flash[:notice] = "Friend request submitted to #{@user.first_name}" if friend_request
    redirect_back(fallback_location: root_path)
  end

  # accept requests
  def update
    return unless current_user.requested_friends.include?(@user)

    current_user.accept_request(@user)
    redirect_back(fallback_location: root_path)
  end

  # unfriend / delete request / reject request
  def destroy
    case params[:format]
    when 'reject_request'
      current_user.decline_request(@user)
      flash[:notice] = "Rejected request from #{@user.first_name}"
    when 'cancel_request'
      current_user.remove_friend(@user)
      flash[:notice] = "Canceled request to #{@user.first_name}"
    else
      return unless current_user.friends_with?(@user)

      current_user.remove_friend(@user)
      flash[:notice] = "UnFriended #{@user.first_name}"
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
