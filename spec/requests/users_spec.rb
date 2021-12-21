# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /index' do
    let!(:rodolfo) { create(:user, :confirmed, username: 'rodolfo') }
    let!(:users) { create_list(:user, 4, :confirmed) }

    before { sign_in(rodolfo) }

    it 'returns all the users in json format when no query param is passed' do
      get '/users'

      users_info = JSON.parse(response.body)
      expect(users_info.count).to eq(5)
    end

    it 'returns all the users in json format when no query param is passed' do
      get '/users', params: { q: 'rodol' }

      users_info = JSON.parse(response.body)

      expect(users_info.count).to eq(1)
      expect(users_info.first['username']).to eq('rodolfo')
    end
  end
end
