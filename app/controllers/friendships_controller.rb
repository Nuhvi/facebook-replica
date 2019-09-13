# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :set_user

  # all friends
  def index; end

  # create request
  def create
    friend_request = current_user.friendships.build(friend_id: params[:user_id])
    if friend_request.save
      flash[:notice] = "Friend request submitted to #{@user.first_name}"
      redirect_back(fallback_location: root_path)
    else
      render 'users/index'
    end
  end

  # unfriend / delete request / reject request
  def destroy
    Friendship.find_for_both(current_user.id, @user.id).destroy

    user_name = @user.first_name

    flash[:notice] = case params[:format]
                     when 'reject_request' then "Rejected request from #{user_name}"
                     when 'cancel_request' then "Canceled request to #{user_name}"
                     else "UnFriended #{user_name}"
                     end

    redirect_back(fallback_location: root_path)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
