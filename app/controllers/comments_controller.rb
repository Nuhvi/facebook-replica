# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[edit update destroy]
  before_action :comment_owner?, only: %i[edit update destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    return unless @comment.save

    flash[:notice] = 'Comment was successfully posted.'
    redirect_back(fallback_location: root_path)
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      flash[:notice] = 'Comment was successfully updated.'
      redirect_to @comment.post
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    flash[:notice] = 'Comment was successfully deleted.'
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_owner?
    redirect_back(fallback_location: root_path) unless @comment.user == current_user
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
