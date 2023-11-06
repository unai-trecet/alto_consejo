require 'rails_helper'

RSpec.describe 'Friendships', type: :request do
  let(:user) { create(:user, :confirmed) }

  describe 'GET /new' do
    it 'returns http success' do
      get '/friendships/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /create' do
    it 'returns http success' do
      get '/friendships/create'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      get '/friendships/update'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /delete' do
    it 'returns http success' do
      get '/friendships/delete'
      expect(response).to have_http_status(:success)
    end
  end
end
