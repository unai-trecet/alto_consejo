# frozen_string_literal: true

class CommentsController < ApplicationController
  include Commentable

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
    @comment.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@comment) }
      format.html { redirect_to @comment.commentable }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
