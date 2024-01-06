# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminsController, type: :request do
  class Admin
    class DummyController < AdminsController
      def index
        render plain: 'Hello, Admin!'
      end
    end
  end

  before(:all) do
    Rails.application.routes.draw do
      namespace :admin do
        resources :dummy, only: [:index]
      end
    end
  end

  after(:all) do
    Rails.application.reload_routes!
  end

  describe 'GET /admins' do
    it 'redirects to root path if user is not an admin' do
      user = create(:user) # Create a regular user
      sign_in user

      get admin_dummy_index_url

      expect(response).to redirect_to(welcome_url)
      expect(flash[:alert]).to eq('You are not authorized to view this page.')
    end

    it 'returns a success response if user is an admin' do
      admin = create(:admin) # Create an admin user
      sign_in admin

      get admin_dummy_index_url

      expect(response).to have_http_status(:success)
    end
  end
end
