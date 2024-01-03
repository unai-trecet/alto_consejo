require 'rails_helper'
require 'factory_bot'

RSpec.describe ReviewsHelper, type: :helper do
  describe '#user_has_reviewed_game?' do
    it 'returns true if the user has reviewed the game' do
      # Create a user and a game using FactoryBot
      user = create(:user, username: 'John Doe')
      game = create(:game, name: 'Super Mario Bros')

      # Create a review for the user and the game
      create(:review, user:, game:, content: 'Great game!')

      # Call the method and expect it to return true
      expect(helper.user_has_reviewed_game?(user, game)).to be true
    end

    it 'returns false if the user has not reviewed the game' do
      # Create a user and a game using FactoryBot
      user = create(:user, username: 'John Doe')
      game = create(:game, name: 'Super Mario Bros')

      # Call the method and expect it to return false
      expect(helper.user_has_reviewed_game?(user, game)).to be false
    end
  end
end
