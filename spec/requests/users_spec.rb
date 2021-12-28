# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:rodolfo) { create(:user, :confirmed, username: 'rodolfo') }

  describe 'GET /index' do
    let!(:users) { create_list(:user, 4, :confirmed) }

    def call_action(params: {}, headers: {})
      get users_path, params: params, headers: headers
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before { sign_in(rodolfo) }

      context 'requesting json' do
        let(:headers) { { 'ACCEPT' => 'application/json' } }

        it 'returns all the users in json format when no query param is passed' do
          call_action(headers: headers)

          users_info = JSON.parse(response.body)
          expect(users_info.count).to eq(5)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(response).to be_successful
        end

        it 'returns all the users in json format when no query param is passed' do
          call_action(params: { q: 'rodol' }, headers: headers)

          users_info = JSON.parse(response.body)

          expect(users_info.count).to eq(1)
          expect(users_info.first['username']).to eq('rodolfo')
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(response).to be_successful
        end
      end

      context 'requesting html' do
        it 'renders index template' do
          call_action(params: { q: 'rodol' })

          expect(response.content_type).to eq('text/html; charset=utf-8')
          expect(response).to be_successful
          expect(response).to render_template(:index)
        end
      end
    end
  end

  describe 'GET /show' do
    def call_action(user = rodolfo)
      get user_path(user)
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before { sign_in(rodolfo) }

      it 'renders inshowex template' do
        call_action

        expect(response).to be_successful
        expect(response).to render_template(:show)
      end
    end
  end
end
