module Commentable
  extend ActiveSupport::Concern
  include ActionView::RecordIdentifier
  include RecordHelper

  def create
    @comment = @commentable.comments.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream
                               .replace(dom_id_for_records(@commentable, @comment), 
                                        partial: 'comments/form', 
                                        locals: { comment: @comment, commentable: @commentable })
        }
        format.html { redirect_to @commentable, notice: @comment.errors.full_messages }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent_id, :user_id)
  end
end
