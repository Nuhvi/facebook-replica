# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[edit update destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    return unless @comment.save

    flash[:notice] = 'Comment was successfully posted.'
    redirect_to root_url
  end

  def edit
    post = @comment.post
  end

  def update; end

  def destroy
    @post.destroy
    redirect_to root_url
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
