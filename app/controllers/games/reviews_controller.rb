class Games::ReviewsController < ApplicationController
  def create
    @review = current_user.reviews.build(review_params.merge(game_id: params[:game_id]))

    if @review.save
      handle_successful_save
    else
      handle_unsuccessful_save
    end
  end

  def destroy
    @review.destroy
    respond_to_destroy
  end

  def edit; end

  def update
    if @review.update(review_params)
      respond_successfully_to_update
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:content)
  end

  def handle_successful_save
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: stream_review + stream_review_form
      end
      format.html { redirect_to @review.game }
    end
  end

  def stream_review
    turbo_stream.replace(
      [@review.game, :reviews],
      partial: 'games/reviews',
      locals: { game: @review.game, user: current_user }
    )
  end

  def stream_review_form
    turbo_stream.replace(
      [@review.game, :review_form],
      target: dom_id(@review.game, :review_form).to_s,
      partial: 'games/reviews/new_review',
      locals: { game: @review.game, user: current_user }
    )
  end

  def handle_unsuccessful_save
    respond_to do |format|
      format.html { redirect_to @review.game, notice: @review.errors.full_messages }
    end
  end

  def respond_to_destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: stream_review_form }
      format.html { redirect_to @review.game }
    end
  end

  def respond_successfully_to_update
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@review, partial: 'games/reviews/review_card',
                                                           locals: { review: @review, user: current_user })
      end
      format.html { redirect_to @review.game }
    end
  end
end
