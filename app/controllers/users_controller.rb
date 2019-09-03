# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @posts = User.find(params[:id]).posts
  end
end
