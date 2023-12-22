class UserFeedComposer
  def initialize(user)
    @user = user
  end

  def call
    Result.new(success: true,
               data: {
                 current_user_played_matches:,
                 current_user_not_played_matches:,
                 recent_public_matches:,
                 recent_comments_from_friends:,
                 recent_comments_on_user_content:,
                 recent_games:
               })
  end

  private

  def current_user_played_matches
    @user.played_matches.order(end_at: :desc).limit(5)
  end

  def current_user_not_played_matches
    @user.not_played_matches
  end

  def recent_public_matches
    Match.open
         .not_played
         .where('created_at > ?', 1.week.ago)
         .where.not(id: @user.matches)
         .where.not(id: @user.participations)
  end

  def recent_comments_from_friends
    @user.friends.map { |friend| friend.authored_comments.where('created_at > ?', 1.week.ago) }.flatten
  end

  def recent_comments_on_user_content
    Comment.where(commentable: @user.games + @user.matches + @user.participations)
           .where('created_at > ?', 1.week.ago)
  end

  def recent_games
    Game.recent
  end
end
