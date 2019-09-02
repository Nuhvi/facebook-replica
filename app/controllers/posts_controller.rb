# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create,:destroy]
  before_action :set_post, only: [:destroy,:show]
  before_action :post_owner?, only: [:destroy]

  def new
    @post = Post.new
    redirect_to new_user_session_path unless current_user
  end

  def edit; end

  def show
    @post 
  end

  def index
    @posts = Post.all
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

  def destroy
    @post.destroy
  end

  private

  def post_owner?
    unless @post.user == current_user
      redirect_to posts_path, alert: "You don't have the authority to delete this post!"
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
