# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Matches::CommentsController, type: :request do
  let(:user) { create(:user, :confirmed) }
  let(:match) { create(:match, user: user) }

  def valid_params(input = {})
    { comment: { body: 'Testing comments under match scope.' }.merge(input) }
  end

  describe 'POST /matches/:match_id/comments' do
    def call_action(match_id: match.id, params: valid_params)
      post "/matches/#{match_id}/comments", params: params
    end

    it_behaves_like 'not_logged_in'

    it 'creates a valid comment belonging match' do
      sign_in(user)

      call_action

      match.reload
      expect(match.comments.count).to eq(1)
      expect(match.comments.last.body.body.as_json).to eq('Testing comments under match scope.')
    end

    it 'does not create a comment if invalid input' do
      sign_in(user)

      call_action(params: valid_params({ body: '' }))

      match.reload
      expect(match.comments.count).to eq(0)
    end
  end
end
