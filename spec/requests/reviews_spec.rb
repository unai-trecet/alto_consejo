require 'rails_helper'

RSpec.describe Games::ReviewsController, type: :request do
  let(:user) { create(:user, :confirmed) }
  let(:game) { create(:game) }

  it_behaves_like 'not_logged_in'

  context 'when authenticated' do
    before do
      sign_in user
    end

    describe 'POST #create' do
      def call_action(params = valid_params, game:)
        post game_reviews_url(game), params:
      end

      context 'with valid parameters' do
        let(:valid_params) do
          { game_id: game.id, review: { content: 'Great game!' } }
        end

        it 'creates a new review' do
          expect do
            call_action(valid_params, game:)
          end.to change(Review, :count).by(1)
        end

        it 'redirects to the game' do
          call_action(valid_params, game:)
          expect(response).to redirect_to(game)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) do
          { game_id: game.id, review: { content: '' } } # content is empty
        end

        it 'does not create a new review' do
          expect do
            call_action(invalid_params, game:)
          end.not_to change(Review, :count)
        end

        it 'redirects to the game' do
          call_action(invalid_params, game:)
          expect(response).to redirect_to(game)
        end
      end
    end
  end
end
