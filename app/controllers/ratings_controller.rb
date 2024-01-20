class RatingsController < ApplicationController
  def create
    @rating = current_user.ratings.build(rating_params)
    if @rating.save
      head :created
    else
      flash[:error] = @rating.errors.full_messages
      head :unprocessable_entity
    end
  end

  def update
    if @rating.update(rating_params)
      respond_to do |format|
        format.turbo_stream do
          stream_rating_update
        end
        format.html { redirect_to @rating.rateable }
      end
    else
      flash[:error] = @rating.errors.full_messages
      head :unprocessable_entity
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:value, :rateable_id, :rateable_type)
  end

  # TODO: make update rating work through stream
  def stream_rating_update # rubocop:disable Metrics/AbcSize
    render turbo_stream: turbo_stream.replace('brasasmente',
                                              target: 'brasasmente',
                                              partial: 'ratings/user_rating_stars',
                                              locals: { rating: @rating })
  end
end
