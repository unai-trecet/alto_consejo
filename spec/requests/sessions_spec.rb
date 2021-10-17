# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /sign_in' do
    it 'renders new template' do
      get '/sign_in'

      expect(response).to render_template(:new)
    end
  end

  describe 'POST /sign_in' do
    let(:password) { '123456' }
    let(:user) { User.create(email: 'test2@test.com', password: password, password_confirmation: password) }

    context 'given correct credentials' do
      it 'sets user id in session' do
        post '/sign_in', params: { email: user.email, password: password }

        expect(session[:user_id]).to eq(user.id)
      end

      it 'redirects to root path' do
        post '/sign_in', params: { email: user.email, password: password }

        expect(response).to redirect_to(root_path)
      end
    end

    context 'given incorrect credentials' do
      let(:wrong_password) { '12345' }

      it 'renders new without setting session' do
        post '/sign_in', params: { email: user.email, password: wrong_password }

        expect(session.key?(:user_id)).to be_falsey
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE /logout' do
    it 'removes user id from session' do
      log_in_user

      expect(session[:user_id]).to be_a(Integer)

      delete '/logout'

      expect(session[:user_id]).to be_nil
    end
  end
end
