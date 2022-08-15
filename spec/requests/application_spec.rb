# frozen_string_literal: true

require 'rails_helper'

class TestController < ApplicationController
  def auth_filtered_action
    render json: { result: 'OK' }
  end
end

RSpec.describe 'Application', type: :request do
  
  let(:user) { create(:user, :confirmed) }

  after(:all) do
    Rails.application.reload_routes!
  end

  describe 'GET /auth_filtered_action' do
    it 'renders normally when user is authenticated' do
      sign_in(user)
      get root_url

      expect(response).to have_http_status 200
    end

    it 'redirects to login page when user is not authenticated' do
      get root_url

      expect(response).to redirect_to '/auth/login'
    end

    it 'redirects to login page when user logs out' do
      sign_in(user)
      get root_url

      expect(response).to have_http_status 200

      sign_out(user)

      get root_url
      expect(response).to redirect_to '/auth/login'
    end
  end
end
