# frozen_string_literal: true

module Commentable
  extend ActiveSupport::Concern
  include ActionView::RecordIdentifier
  include RecordHelper

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        comment = Comment.new
        format.turbo_stream do
          render turbo_stream: turbo_stream
            .replace(dom_id_for_records(@commentable, comment),
                     partial: 'comments/form',
                     locals: { comment: comment, commentable: @commentable })
        end
        format.html { redirect_to @commentable }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream
            .replace(dom_id_for_records(@commentable, @comment),
                     partial: 'comments/form',
                     locals: { comment: @comment, commentable: @commentable })
        end
        format.html { redirect_to @commentable, notice: @comment.errors.full_messages }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end
end
