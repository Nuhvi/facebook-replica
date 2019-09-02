# frozen_string_literal: true

class PostsController < ApplicationController
  def new
    redirect_to new_user_session_path unless current_user
  end

  def edit; end

  def show; end

  def index; end
end
