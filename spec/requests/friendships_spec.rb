require 'rails_helper'

RSpec.describe 'Friendships', type: :request do # rubocop:disable Metrics/BlockLength
  let(:user) { create(:user, :confirmed) }

  before { sign_in(user) }

  describe 'GET /new' do
    xit 'returns http success' do
      get '/friendships/new'
      expect(response).to be_successful
    end
  end

  describe 'GET /create' do
    xit 'returns http success' do
      get '/friendships/create'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /update' do
    xit 'returns http success' do
      get '/friendships/update'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /delete' do
    xit 'returns http success' do
      get '/friendships/delete'
      expect(response).to have_http_status(:success)
    end
  end
end
