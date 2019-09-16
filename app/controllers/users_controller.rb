# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @posts = User.find(params[:id]).posts
  end

  def index
    @users = current_user.strangers
  end
end
