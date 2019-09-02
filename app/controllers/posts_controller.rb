# frozen_string_literal: true

class PostsController < ApplicationController
  def new
    @post = Post.new
    redirect_to new_user_session_path unless current_user
  end

  def edit; end

  def show; end

  def index
    @posts = User.find(params[:user_id])
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      # flash[:notice] = 'Post was successfully created.'
      redirect_to @post
    else
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
