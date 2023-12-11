# spec/requests/ratings_controller_spec.rb

require 'rails_helper'

RSpec.describe RatingsController, type: :request do
  let(:user) { create(:user, :confirmed) }
  let(:rateable) { create(:game) } # replace :game with your rateable model
  let(:valid_attributes) { { value: 5, rateable_id: rateable.id, rateable_type: rateable.class.name } }
  let(:invalid_attributes) { { value: nil, rateable_id: rateable.id, rateable_type: rateable.class.name } }

  describe 'POST /create' do
    def call_action(params = valid_attributes)
      post ratings_url, params: { rating: params }
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before { sign_in user }
      context 'with valid parameters' do
        it 'creates a new rating' do
          expect { call_action(valid_attributes) }.to change(Rating, :count).by(1)
        end

        it 'responds with 201' do
          call_action(valid_attributes)
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new rating' do
          expect { call_action(invalid_attributes) }.to change(Rating, :count).by(0)
        end

        it 'responds with 422' do
          call_action(invalid_attributes)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
