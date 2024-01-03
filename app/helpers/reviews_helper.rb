module ReviewsHelper
  def user_has_reviewed_game?(user, game)
    user.reviews.exists?(game:)
  end
end
