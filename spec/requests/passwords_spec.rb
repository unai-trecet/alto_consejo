# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  describe 'GET /password' do
    context 'when authenticated' do
      before { sign_in_user }

      it 'renders edit template' do
        get '/password'

        expect(response).to render_template(:edit)
      end
    end

    context 'when not authenticated' do
      it 'renders edit template' do
        get '/password'

        expect(response).to redirect_to(sign_in_path)
      end
    end
  end

  describe 'PATCH /password' do
    context 'when authenticated' do
      let(:password) { '87654321' }
      let(:user) { User.create(email: 'test2@test.com', password: password, password_confirmation: password) }
      before { sign_in_user(user) }

      context 'with valid input' do
        it 'updates user password edit template' do
          new_password = '12345678'

          patch '/password', params: { user: { password: new_password, password_confirmation: new_password } }

          expect(user.reload.authenticate(new_password)).to eq(user)
          expect(response).to redirect_to(root_path)
        end
      end

      context 'with invalid input' do
        it 'does not change password and renders edit template' do
          new_password = 'new_password'
          # password and password_confirmation params differ.
          patch '/password', params: { user: { password: new_password, password_confirmation: new_password[0..-2] } }

          expect(user.reload.authenticate(new_password)).to be_falsey
          expect(user.reload.authenticate(password)).to eq(user)
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when not authenticated' do
      it 'renders edit template' do
        patch '/password'

        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
end
