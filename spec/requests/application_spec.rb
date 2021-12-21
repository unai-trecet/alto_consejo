# frozen_string_literal: true

require 'rails_helper'

class TestController < ApplicationController
  def auth_filtered_action
    render json: { result: 'OK' }
  end
end

RSpec.describe 'Application', type: :request do
  before(:all) do
    Rails.application.routes.draw do
      get 'auth_filtered_action' => 'test#auth_filtered_action'

      devise_for :users,
                 path: 'auth',
                 path_names: {
                   sign_in: 'login',
                   sign_out: 'logout',
                   password: 'secret',
                   confirmation: 'verification',
                   registration: 'register',
                   sign_up: 'cmon_let_me_in'
                 },
                 controllers: {
                   confirmations: 'users/confirmations',
                   passwords: 'users/passwords',
                   registrations: 'users/registrations',
                   sessions: 'users/sessions'
                 }
    end
  end

  after(:all) do
    Rails.application.reload_routes!
  end

  describe 'GET /auth_filtered_action' do
    it 'renders normally when user is authenticated' do
      sign_in create(:user, :confirmed)
      get '/auth_filtered_action'

      expect(response).to have_http_status 200
      expect(JSON.parse(response.body)).to eq({ 'result' => 'OK' })
    end

    it 'redirects to login page when user is not authenticated' do
      get '/auth_filtered_action'

      expect(response).to redirect_to '/auth/login'
    end
  end
end
