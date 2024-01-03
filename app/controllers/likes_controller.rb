class LikesController < ApplicationController
  before_action :find_likeable

  def like
    if current_user.voted_up_on?(@likeable)
      @likeable.unvote_by(current_user)
    else
      @likeable.upvote_by(current_user)
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace([@likeable, :heart_icon],
                                                  target: dom_id(@likeable, :heart_icon),
                                                  partial: 'shared/like_heart',
                                                  locals: { likeable: @likeable,
                                                            liked: @likeable.voted_up_by?(current_user) })
      end
      format.html { redirect_to @likeable }
    end
  end

  private

  def find_likeable
    @likeable = params[:likeable_type].classify.constantize.find(params[:likeable_id])
  end
end
