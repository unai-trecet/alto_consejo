class UserFeedComposer
  def initialize(user)
    @user = user
  end

  def call
    Result.new(success: true, data: compose_data)
  end

  private

  def compose_data # rubocop:disable Metrics/AbcSize
    {
      user_played_matches_count: user_played_matches.size,
      user_played_matches: user_played_matches.take(5),
      user_not_played_matches_count: user_not_played_matches.size,
      user_not_played_matches: user_not_played_matches.take(5),
      user_organised_matches_count: user_organised_matches.size,
      user_organised_matches: user_organised_matches.take(5),
      user_played_games_count: user_played_games.size,
      user_played_games: user_played_games.take(5),
      recent_public_matches:,
      recent_comments_from_friends:,
      recent_comments_on_user_content:
    }
  end

  def user_played_matches
    @user_played_matches ||= @user.played_matches.order(end_at: :desc).to_a
  end

  def user_not_played_matches
    @user_not_played_matches ||= @user.not_played_matches.to_a
  end

  def user_organised_matches
    @user_organised_matches ||= @user.matches.to_a
  end

  def user_played_games
    @user_played_games ||= @user.played_games
  end

  def recent_public_matches
    Match.open
         .not_played
         .where('start_at > ?', DateTime.now)
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
end
