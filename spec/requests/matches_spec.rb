# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/matches', type: :request do
  let(:user) { create(:user, :confirmed) }
  let(:game) { create(:game, user: user) }

  let(:valid_params) do
    {
      title: 'Testing matches',
      description: 'I hope they pass.',
      user_id: user.id,
      game_id: game.id,
      location: 'my place',
      number_of_players: 3,
      start_at: '2021-11-24 18:09:43',
      end_at: '2021-11-24 18:09:43'
    }
  end

  def set_params(params = {})
    valid_params.merge(params)
  end

  let(:invalid_params) do
    {
      title: '',
      description: 'I hope they pass.',
      user: user,
      game: create(:game),
      location: 'my place',
      number_of_players: 5,
      start_at: '2021-11-24 18:09:43',
      end_at: '2021-11-24 18:09:43'
    }
  end

  describe 'GET /index' do
    def call_action
      get matches_url
    end

    it_behaves_like 'not_logged_in'

    context 'user authenticated' do
      before { sign_in(user) }

      it 'renders a successful response' do
        Match.create! valid_params

        call_action

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    def call_action(match = create(:match))
      get match_url(match)
    end

    it_behaves_like 'not_logged_in'

    context 'user authenticated' do
      before { sign_in(user) }

      it 'renders a successful response' do
        call_action
        expect(response).to be_successful
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET /new' do
    def call_action
      get new_match_url
    end

    it_behaves_like 'not_logged_in'

    context 'user authenticated' do
      before { sign_in(user) }

      it 'renders a successful response' do
        call_action

        expect(response).to be_successful
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET /edit' do
    def call_action(match = create(:match, valid_params))
      get edit_match_url(match)
    end

    it_behaves_like 'not_logged_in'

    context 'user authenticated' do
      before { sign_in(user) }

      it 'render a successful response' do
        call_action

        expect(response).to be_successful
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'POST /create' do
    let(:invited_users) { create_list(:user, 2) }
    let(:valid_params_with_usernames) do
      set_params({ usernames: "@#{invited_users.first.username} @#{invited_users.last.username}" })
    end

    def call_action(params = valid_params_with_usernames)
      post matches_url, params: { match: params }
    end

    it_behaves_like 'not_logged_in'

    context 'user authenticated' do
      before do
        sign_in(user)
      end

      context 'with valid parameters' do
        it 'creates a new Match notifying invited users' do
          invited_users
          expect_any_instance_of(ManageMatchParticipants).to receive(:call).and_call_original

          expect do
            call_action(valid_params_with_usernames)
          end.to change(Match, :count).by(1)

          expect(ActionMailer::Base.deliveries.count).to eq(invited_users.count)
          expect(ActionMailer::Base.deliveries.map { |el| el.to.join })
            .to match_array(invited_users.pluck(:email))
        end

        it 'redirects to the created match' do
          call_action(valid_params_with_usernames)

          expect(response).to redirect_to(match_url(Match.last))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Match' do
          expect do
            call_action(invalid_params)
          end.to change(Match, :count).by(0)
        end

        it "renders a successful response (i.e. to display the 'new' template)" do
          call_action(invalid_params)

          expect(response).to render_template(:new)
          expect(response).to have_http_status(422)
        end
      end
    end
  end

  describe 'PATCH /update' do
    let(:match) { create(:match, set_params({ title: 'Old title' })) }

    def call_action(params = valid_params)
      patch match_url(match), params: { match: params }
    end

    it_behaves_like 'not_logged_in'

    context 'user authenticated' do
      before { sign_in(user) }

      context 'with valid parameters' do
        let(:new_params) do
          set_params({ title: 'New title' })
        end

        it 'updates the requested match' do
          expect(match.title).to eq('Old title')

          call_action(new_params)

          match.reload
          expect(match.title).to eq('New title')
        end

        it 'redirects to the match' do
          call_action(new_params)

          match.reload
          expect(response).to redirect_to(match_url(match))
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

  describe 'DELETE /destroy' do
    let!(:match) { create(:match, valid_params) }

    def call_action
      delete match_url(match)
    end

    it_behaves_like 'not_logged_in'

    context 'user authenticated' do
      before { sign_in(user) }

      it 'destroys the requested match' do
        expect do
          call_action
        end.to change(Match, :count).from(1).to(0)
      end

      it 'redirects to the matches list' do
        call_action

        expect(response).to redirect_to(matches_url)
      end
    end
  end
end
