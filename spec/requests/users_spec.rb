# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:password) { '12345678' }
  let(:valid_params) do
    {
      email: 'rodolfo@test.com',
      username: 'rodolfo',
      password:,
      password_confirmation: password,
      avatar: fixture_file_upload('default_avatar.png', '/spec/fixtures/')
    }
  end

  let(:invalid_params) { valid_params.merge({ username: nil }) }

  let!(:rodolfo) { create(:user, :confirmed, valid_params) }

  def after_teardown
    super
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end

  def set_params(input = {})
    valid_params.merge(input)
  end

  describe 'GET /index' do
    let!(:users) { create_list(:user, 4, :confirmed) }

    def call_action(params: {}, headers: {})
      get users_path, params:, headers:
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before { sign_in(rodolfo) }

      context 'requesting json' do
        let(:headers) { { 'ACCEPT' => 'application/json' } }

        it 'returns all the users in json format when no query param is passed' do
          call_action(headers:)

          users_info = JSON.parse(response.body)
          expect(users_info.count).to eq(5)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(response).to be_successful
        end

        it 'returns all the users in json format when no query param is passed' do
          call_action(params: { q: 'rodol' }, headers:)

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

  describe 'GET /edit' do
    def call_action(user = rodolfo)
      get edit_user_url(user)
    end

    it_behaves_like 'not_logged_in'

    context 'user authenticated' do
      before { sign_in(rodolfo) }

      it 'render a successful response' do
        call_action

        expect(response).to be_successful
        expect(response).to render_template(:edit)
      end

      it 'redirects to root if user is not current user' do
        user = create(:user, :confirmed)

        call_action(user)

        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq('No estás autorizado a realizar esa acción.')
      end
    end
  end

  describe 'PATCH /update' do
    let(:user) do
      create(:user, :confirmed,
             set_params({ username: 'old_username', email: 'other@email.com' }))
    end

    def call_action(params = valid_params)
      patch user_url(user), params: { user: params }
    end

    it_behaves_like 'not_logged_in'

    context 'user authenticated' do
      before { sign_in(user) }

      context 'with valid parameters' do
        it 'updates the requested user username' do
          expect(user.username).to eq('old_username')

          new_params = set_params({ username: 'new_username' })
          call_action(new_params)

          user.reload
          expect(user.username).to eq('new_username')
          expect(response).to redirect_to(user_url(user))
        end

        it 'does not update any other attribute but username and avatar' do
          expect(user.username).to eq('old_username')
          expect(user.valid_password?(password)).to eq(true)

          new_pass = '87654321'
          new_params = { username: 'new_username',
                         email: 'another@email.com',
                         password: new_pass,
                         password_confirmation: new_pass,
                         avatar: fixture_file_upload('avatar2.jpg', '/spec/fixtures/') }

          call_action(new_params)

          user.reload
          expect(user.valid_password?(new_pass)).to eq(false)
          expect(user.username).to eq('new_username')
          expect(user.email).to eq('other@email.com')
          expect(user.avatar.filename.as_json).to eq('avatar2.jpg')
        end

        it 'does not update user if user is not the logged in user' do
          sign_out(user)
          sign_in(rodolfo)
          expect(user.username).to eq('old_username')

          new_params = set_params({ username: 'new_username' })
          call_action(new_params)

          user.reload
          expect(user.username).to eq('old_username')
          expect(response).to redirect_to(root_path)
          expect(flash[:error]).to eq('No estás autorizado a realizar esa acción.')
        end
      end

      context 'with invalid parameters' do
        it "renders a successful response (i.e. to display the 'edit' template)" do
          call_action(invalid_params)

          expect(response).to render_template(:edit)
          expect(response).to have_http_status(422)
        end
      end
    end
  end

  describe 'GET /search_game_name' do
    def call_action(search_input = '')
      get username_search_url, params: { q: search_input }
    end

    it_behaves_like 'not_logged_in'

    it 'renders a successful response' do
      sign_in rodolfo
      create(:user, username: 'testing_success1')
      create(:user, username: 'testing_success2')
      call_action('test')

      expect(response).to be_successful
      expect(response).to render_template('shared/_autocomplete')
      # The returned html chunk highlight the matching names inlcuding some mark up.
      expect(response.body).to include('test').twice
      expect(response.body).to include('_success1')
      expect(response.body).to include('_success2')
    end
  end

  describe 'DELETE /purge_avatar' do
    let!(:user_with_avatar) do
      create(:user, :confirmed, avatar: fixture_file_upload('avatar2.jpg', '/spec/fixtures/'))
    end

    def call_action(user = user_with_avatar)
      delete purge_avatar_user_url(user)
    end

    it_behaves_like 'not_logged_in'

    describe 'authenticated user' do
      before { sign_in user_with_avatar }

      it 'deletes user avatar' do
        call_action(user_with_avatar)

        user_with_avatar.reload

        expect(user_with_avatar.avatar.attached?).to eq(false)
        expect(response).to have_http_status(302)
      end

      it 'does not delete the avatar if logged in user is not the user' do
        another_user = create(:user, :confirmed)
        another_user.avatar.attach(
          io: File.open(Rails.root.join('app', 'assets', 'images', 'default_avatar.png')),
          filename: 'default_avatar.png',
          content_type: 'image/png'
        )

        call_action(another_user)

        another_user.reload

        expect(another_user.avatar.attached?).to eq(true)
        expect(response).to have_http_status(302)
      end
    end
  end
end
