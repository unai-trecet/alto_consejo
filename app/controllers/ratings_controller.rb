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

  private

  def rating_params
    params.require(:rating).permit(:value, :rateable_id, :rateable_type)
  end
end
