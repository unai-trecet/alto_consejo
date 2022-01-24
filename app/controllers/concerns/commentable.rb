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
    @comment.parent_id = @parent&.id

    respond_to do |format|
      if @comment.save
        format.turbo_stream do
          comment = Comment.new
          if @parent
            # A successful reply to another comment, replace and hide this form
            render turbo_stream: turbo_stream
              .replace(dom_id_for_records(@parent, comment),
                       partial: 'comments/form',
                       locals: { comment: comment,
                                 commentable: @parent,
                                 data: { comment_reply_target: 'form' },
                                 class: 'd-none' })
          else
            render turbo_stream: turbo_stream
              .replace(dom_id_for_records(@commentable, comment),
                       partial: 'comments/form',
                       locals: { comment: comment, commentable: @commentable })
          end
        end
        format.html { redirect_to @commentable }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream
            .replace(dom_id_for_records(@parent || @commentable, @comment),
                     partial: 'comments/form',
                     locals: { comment: @comment, commentable: @parent || @commentable })
        end
        format.html { redirect_to @commentable, notice: @comment.errors.full_messages }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
