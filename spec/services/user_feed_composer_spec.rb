require 'rails_helper'

RSpec.describe UserFeedComposer do
  describe '#call' do
    let(:user) { create(:user, :confirmed) }
    let(:composer) { UserFeedComposer.new(user) }

    it 'returns a composed user feed' do
      user_game = create(:game, user:)
      create_list(:game, 5)

      organised_match = create(:match, title: 'organised_match', user:, public: false, end_at: 1.day.ago)
      create(:match_participant, user:, match: organised_match)

      played_match = create(:match, title: 'played_match', public: true, end_at: 1.day.ago)
      create(:match_participant, user:, match: played_match)

      not_played_match = create(:match, title: 'not_played_match', public: true, end_at: DateTime.now + 1)
      create(:match_participant, user:, match: not_played_match)
      public_match = create(:match, title: 'public_match', public: true, start_at: DateTime.now + 1)

      _not_participated_played_match = create(:match, title: '_not_participated_played_match', public: true, end_at: 2.day.ago)
      _not_public_match = create(:match, title: '_not_public_match', public: false, end_at: DateTime.now + 1)
      _old_public_match = create(:match, title: '_old_public_match', public: true, start_at: 8.days.ago)

      friend = create(:user, :confirmed)
      create(:friendship, user:, friend:, accepted_at: DateTime.now)

      comment_from_friend = create(:comment, user: friend, created_at: 1.day.ago)

      comment_on_user_game = create(:comment, commentable: user_game, created_at: 1.day.ago)
      comment_on_user_played_match = create(:comment, commentable: played_match, created_at: 2.day.ago)
      comment_on_user_organised_match = create(:comment, commentable: organised_match, created_at: 3.day.ago)
      _old_comment_on_user_organised_match = create(:comment, commentable: organised_match, created_at: 8.day.ago)

      result = composer.call

      expect(result.success).to eq(true)
      expect(result.data).to be_a(Hash)
      expect(result.data.keys).to contain_exactly(
        :user_played_matches_count,
        :user_played_matches,
        :user_not_played_matches_count,
        :user_not_played_matches,
        :user_organised_matches_count,
        :user_organised_matches,
        :user_played_games_count,
        :user_played_games,
        :recent_public_matches,
        :recent_comments_from_friends,
        :recent_comments_on_user_content
      )

      expect(result.data[:user_played_matches_count]).to eq(2)
      expect(result.data[:user_played_matches]).to match_array([played_match, organised_match])
      expect(result.data[:user_not_played_matches_count]).to eq(1)
      expect(result.data[:user_not_played_matches]).to match_array([not_played_match])
      expect(result.data[:user_organised_matches_count]).to eq(1)
      expect(result.data[:user_organised_matches]).to match_array([organised_match])
      expect(result.data[:user_played_games_count]).to eq(2)
      expect(result.data[:user_played_games]).to match_array([played_match.game, organised_match.game])
      expect(result.data[:recent_public_matches]).to match_array([public_match])
      expect(result.data[:recent_comments_from_friends]).to match_array([comment_from_friend])
      expect(result.data[:recent_comments_on_user_content]).to match_array([comment_on_user_game,
                                                                            comment_on_user_played_match, 
                                                                            comment_on_user_organised_match])
    end
  end
end
