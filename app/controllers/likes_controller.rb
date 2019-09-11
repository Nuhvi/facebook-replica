# frozen_string_literal: true

class LikesController < ApplicationController

  def index

  end

  def create
    likeable = like_params[:likeable_type].constantize.find(like_params[:likeable_id])

    return if already_liked

    likeable.likes.create(user: current_user)
    flash[:notice] = "#{like_params[:likeable_type]} was successfully Liked."
    redirect_to root_url
  end

  def destroy; end

  private

  def already_liked
    !current_user.likes.find_by(likeable_id: like_params[:likeable_id], likeable_type: like_params[:likeable_type]).nil?
  end

  def like_params
    params.require(:like).permit(:likeable_id, :likeable_type)
  end
end
