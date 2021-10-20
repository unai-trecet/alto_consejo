# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PasswordResets', type: :request do
  describe 'GET /password/reset' do
    it 'renders new template' do
      get '/password/reset'

      expect(response).to render_template(:new)
    end
  end

  describe 'POST /password/reset' do
    it 'sends reset password email to user' do
      email = 'testing_create@test.com'
      create(:user, email: email)

      expect { post '/password/reset', params: { email: email } }
        .to have_enqueued_job(ActionMailer::MailDeliveryJob)
        .with('PasswordMailer', 'reset', 'deliver_now', Hash)

      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET /password/reset/edit' do
    context 'with a valid token' do
      it 'renders edit template when valid token is passed' do
        user = create(:user)
        # token generation based on user
        reset_token = user.signed_id(purpose: 'password_reset', expires_in: 15.minutes)

        get '/password/reset/edit', params: { token: reset_token }

        expect(response).to render_template(:edit)
      end
    end

    context 'with invalid token' do
      it 'redirects to sign in path if token has expired' do
        user = create(:user)
        # token generation based on user
        reset_token = user.signed_id(purpose: 'password_reset', expires_in: 15.minutes)

        # Set time one minute after expiration
        Timecop.freeze(Time.current + 16.minutes) do
          get '/password/reset/edit', params: { token: reset_token }

          expect(response).to redirect_to(sign_in_path)
        end
      end
    end
  end

  describe 'PATCH /password/reset/edit' do
    context 'with a valid token and valid params' do
      it 'updates user passsword and redirects_to sign in path' do
        user = create(:user, password: '87654321', password_confirmation: '87654321')
        reset_token = user.signed_id(purpose: 'password_reset', expires_in: 15.minutes)
        new_password = '12345678'
        valid_params = { token: reset_token, user: { password: new_password, password_confirmation: new_password } }

        patch '/password/reset/edit', params: valid_params

        expect(user.reload.authenticate(new_password)).to eq(user)
      end
    end

    context 'with invalid token or input' do
      it 'redirects to sign in path if token has expired' do
        user = create(:user, password: '87654321', password_confirmation: '87654321')
        expired_token = user.signed_id(purpose: 'password_reset', expires_in: 15.minutes)
        new_password = '12345678'
        invalid_params = { token: expired_token, user: { password: new_password, password_confirmation: new_password } }

        # Set time one minute after expiration
        Timecop.freeze(Time.current + 16.minutes) do
          get '/password/reset/edit', params: invalid_params

          expect(response).to redirect_to(sign_in_path)
        end
      end

      it 'does no change password if input differs' do
        user = create(:user, password: '87654321', password_confirmation: '87654321')
        reset_token = user.signed_id(purpose: 'password_reset', expires_in: 15.minutes)
        new_password = '123456780'
        invalid_params = { token: reset_token,
                           user: { password: new_password, password_confirmation: new_password[0..-2] } }

        get '/password/reset/edit', params: invalid_params

        expect(response).to render_template(:edit)
      end
    end
  end
end
