# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MatchParticipants', type: :request do
  describe 'POST /create' do
    let(:user) { create(:user, :confirmed) }
    let(:match) { create(:match) }
    let(:valid_params) { { user_id: user.id, match_id: match.id } }

    def set_params(attrs = {})
      valid_params.merge(attrs)
    end

    def call_action(params = valid_params)
      post '/match_participants', params: params
    end

    it_behaves_like 'not_logged_in'

    context 'when user logged in' do
      before { sign_in(user) }

      it 'returns http success and creates a participant' do
        expect do
          call_action
        end.to change(MatchParticipant, :count).from(0).to(1)

        match = MatchParticipant.last.match
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(match_path(match))
      end

      it 'return fail status when match_participant could not be created' do
        expect do
          call_action(set_params({ user_id: nil }))
        end.not_to change(MatchParticipant, :count)

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:participant) { create(:match_participant) }
    let(:valid_params) { participant }

    def call_action(params = valid_params)
      delete match_participant_url(params)
    end

    it_behaves_like 'not_logged_in'

    context 'when user authenticated' do
      let(:user) { create(:user, :confirmed) }

      before { sign_in(user) }

      it 'deletes the participant when the participant is the current_user' do
        user_participant = create(:match_participant, user: user)

        expect do
          call_action(user_participant)
        end.to change(MatchParticipant, :count).from(1).to(0)

        expect(response).to have_http_status(:success)
      end

      it 'deletes the participant when the user was the creator of the match' do
        match = create(:match, user: user)
        a_participant = create(:match_participant, match: match)

        expect do
          call_action(a_participant)
        end.to change(MatchParticipant, :count).from(1).to(0)

        expect(response).to have_http_status(:success)
      end

      it 'does not delete the participant when the user is not a participant or the creator of the match' do
        sign_in(user)
        new_participant = create(:match_participant)

        expect do
          call_action(new_participant)
        end.not_to change(MatchParticipant, :count)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
