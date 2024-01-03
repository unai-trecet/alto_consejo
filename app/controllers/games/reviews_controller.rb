class Games::ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @game = Game.find(params[:game_id])
    @review = @game.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      respond_to do |format|
        format.turbo_stream do
          stream_created_review
        end

        format.html { redirect_to @game }
      end
    else
      respond_to do |format|
        format.html { redirect_to @game, notice: @review.errors.full_messages }
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:content)
  end

  def stream_created_review
    render turbo_stream: turbo_stream.replace(
      [@review.game, :review_form],
      target: dom_id(@review.game, :review_form).to_s,
      partial: 'games/reviews/form',
      locals: { game: @review.game, user: current_user }
    )
  end
end
