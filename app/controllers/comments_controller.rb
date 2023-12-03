# frozen_string_literal: true

class CommentsController < ApplicationController
  include Commentable

  before_action :set_comment

  def show; end

  def edit; end

  def update
    if @comment.user == current_user
      if @comment.update(comment_params)
        render @comment
      else
        render :edit, status: :unprocessable_entity
      end
    else
      flash[:notice] = 'You are not authorized to edit this comment.'
      head :unauthorized
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      respond_to do |format|
        format.turbo_stream { head :ok }
        format.html { redirect_to @comment.commentable }
      end
    else
      flash[:notice] = 'You are not authorized to delete this comment.'
      head :unauthorized
    end
  end

  def upvote
    if current_user.voted_up_on?(@comment)
      @comment.unvote_by(current_user)
    else
      @comment.upvote_by(current_user)
    end

    head :ok
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
