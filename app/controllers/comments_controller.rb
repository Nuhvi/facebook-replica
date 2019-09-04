# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save

    else
      redirect_to root_url
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
