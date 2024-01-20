require 'rails_helper'

RSpec.describe Games::ReviewsController, type: :request do
  let(:user) { create(:user, :confirmed) }
  let(:game) { create(:game) }

  describe 'POST #create' do
    def call_action(params = { game_id: game.id, review: { content: 'Great game!' } })
      post game_reviews_url(game), params:
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before do
        sign_in user
      end

      context 'with valid parameters' do
        let(:valid_params) do
          { game_id: game.id, review: { content: 'Great game!' } }
        end

        it 'creates a new review' do
          expect do
            call_action(valid_params)
          end.to change(Review, :count).by(1)
        end

        it 'redirects to the game' do
          call_action(valid_params)
          expect(response).to redirect_to(game)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) do
          { game_id: game.id, review: { content: '' } } # content is empty
        end

        it 'does not create a new review' do
          expect do
            call_action(invalid_params)
          end.not_to change(Review, :count)
        end

        it 'redirects to the game' do
          call_action(invalid_params)
          expect(response).to redirect_to(game)
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:review) { create(:review, game:, user:) }
    let(:valid_params) { { review: { content: 'Updated content!' } } }
    let(:invalid_params) { { review: { content: '' } } } # content is empty

    def call_action(params = valid_params)
      patch game_review_url(game, review), params:
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before do
        sign_in user
      end

      context 'with valid parameters' do
        it 'updates the review' do
          call_action(valid_params)
          review.reload
          expect(review.content.body.to_plain_text).to eq('Updated content!')
        end

        it 'redirects to the game' do
          call_action(valid_params)
          expect(response).to redirect_to(game)
        end
      end

      context 'with invalid parameters' do
        it 'does not update the review' do
          call_action(invalid_params)
          review.reload
          expect(review.content).not_to eq('')
        end

        it 'renders the edit view' do
          call_action(invalid_params)
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when the user is not the creator of the review' do
      let(:other_user) { create(:user, :confirmed) }

      before do
        sign_in other_user
      end

      it 'does not update the review' do
        call_action(valid_params)
        review.reload
        expect(review.content.body.to_plain_text).not_to eq('Updated content!')
        expect(response).to redirect_to(unauthorized_path)
      end
    end

    context 'when the user is an admin' do
      let(:admin) { create(:user, :admin) }

      before do
        sign_in admin
      end

      context 'with valid parameters' do
        it 'updates the review' do
          call_action(valid_params)
          review.reload
          expect(review.content.body.to_plain_text).to eq('Updated content!')
        end

        it 'redirects to the game' do
          call_action(valid_params)
          expect(response).to redirect_to(game)
        end
      end

      context 'with invalid parameters' do
        it 'does not update the review' do
          call_action(invalid_params)
          review.reload
          expect(review.content).not_to eq('')
        end

        it 'renders the edit view' do
          call_action(invalid_params)
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:review) { create(:review, game:, user:) }

    def call_action
      delete game_review_url(game, review)
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before do
        sign_in user
      end

      it 'deletes the review' do
        expect do
          call_action
        end.to change(Review, :count).by(-1)
      end

      it 'redirects to the game' do
        call_action
        expect(response).to redirect_to(game)
      end
    end

    context 'when the user is not the creator of the review' do
      let(:other_user) { create(:user, :confirmed) }

      before do
        sign_in other_user
      end

      it 'does not delete the review and responds with unauthorized' do
        expect do
          call_action
        end.not_to change(Review, :count)
        expect(response).to redirect_to(unauthorized_path)
      end
    end

    context 'when the user is an admin' do
      let(:admin) { create(:user, :admin) }

      before do
        sign_in admin
      end

      it 'deletes the review' do
        expect do
          call_action
        end.to change(Review, :count).by(-1)
      end

      it 'redirects to the game' do
        call_action
        expect(response).to redirect_to(game)
      end
    end
  end
end
