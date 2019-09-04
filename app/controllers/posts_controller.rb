# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[show edit update destroy]
  before_action :post_owner?, only: %i[edit update destroy]

  def index
    @post = Post.new
    @posts = Post.all
    @comment = current_user.comments.build
  end

  def show; end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = 'Post was successfully created.'
      redirect_to @post
    else
      render :new
    end
  end

  def update
    render :edit unless @post.update(post_params)
  end

  def destroy
    @post.destroy
    redirect_to root_url
  end

  private

  def post_owner?
    redirect_to root_url unless @post.user == current_user
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
