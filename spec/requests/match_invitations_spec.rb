# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MatchInvitations', type: :request do
  describe 'GET /create' do
    xit 'returns http success' do
      get '/match_invitations/create'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /destroy' do
    xit 'returns http success' do
      get '/match_invitations/destroy'
      expect(response).to have_http_status(:success)
    end
  end
end
