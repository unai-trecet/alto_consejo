require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  describe 'GET /welcome' do
    it 'does not redirect to login page when the user is not logged in' do
      get '/welcome'

      expect(response.status).to eq(200)
    end
  end

  describe 'GET /dashboard' do
    it 'does not redirect to login page when the user is not logged in' do
      get '/dashboard'

      expect(response.status).to redirect_to '/auth/login'
    end
  end
end
