# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @posts = User.find(params[:id]).posts
  end
end
