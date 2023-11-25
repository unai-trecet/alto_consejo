# frozen_string_literal: true

class CommentsController < ApplicationController
  include Commentable

  before_action :set_comment

  def show; end

  def edit; end

  def update
    if @comment.update(comment_params)
      render @comment
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    commentable = @comment.commentable
    @comment.destroy
    respond_to do |format|
      format.turbo_stream {}
      format.html { redirect_to commentable }
    end
  end

  private

  def set_comment
    @comment = current_user.authored_comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
