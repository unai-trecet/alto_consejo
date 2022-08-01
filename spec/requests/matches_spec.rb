# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/matches', type: :request do
  let(:user) { create(:user, :confirmed) }
  let(:game) { create(:game, user: user) }
  let(:invited_users) { create_list(:user, 2) }

  let(:valid_params) do
    {
      title: 'Testing matches',
      description: 'I hope they pass.',
      user_id: user.id,
      game_id: game.id,
      location: 'my place',
      number_of_players: 3,
      invited_users: "#{invited_users.first.username} #{invited_users.last.username}",
      start_at: '2021-11-24 18:09:43',
      end_at: '2021-11-24 18:09:43',
      public: false
    }
  end

  let(:valid_params_with_creator_participates) do
    valid_params.merge(creator_participates: true)
  end

  def set_params(params = {})
    valid_params.merge(params)
  end

  let(:invalid_params) { valid_params.merge(title: nil) }

  describe 'GET /index' do
    def call_action(params: {}, format: 'html')
      get matches_url(params: params, format: format)
    end

    it_behaves_like 'not_logged_in'

    context 'user authenticated' do
      before { sign_in(user) }

      it 'renders a successful response' do
        create(:match, valid_params)

        call_action

        expect(response).to be_successful
      end

      context 'filtering' do
        let(:another_user) { create(:user, :confirmed) }
        let!(:not_public_match) do
          create(:match, set_params({ title: 'Not public Match', user_id: another_user.id, public: false }))
        end
        let!(:public_match) do
          create(:match, set_params({ title: 'Public Match', public: true, user_id: another_user.id }))
        end
        let!(:invitation_match) do
          create(:match, set_params({ title: 'Invitation Match', user_id: another_user.id }))
        end
        let!(:participation_match) do
          create(:match, set_params({ title: 'Participation Match', user_id: another_user.id }))
        end
        let!(:created_match) do
          create(:match, set_params(title: 'Created Match'))
        end

        before do
          create(:match_invitation, match: invitation_match, user: user)
          create(:match_participant, match: participation_match, user: user)
        end

        it 'returns basic filtered matches when no filter is passed' do
          call_action(format: 'json')

          matches_data = JSON.parse(response.body)
          expect(response).to be_successful
          expect(Match.count).to eq(5)
          expect(matches_data.size).to eq(4)
          expect(matches_data.map do |match|
                   match['title']
                 end).to match_array(['Public Match', 'Invitation Match', 'Participation Match', 'Created Match'])
          expect(matches_data.map do |match|
                   match['id']
                 end).to match_array([public_match.id, invitation_match.id, participation_match.id, created_match.id])
        end

        it 'returns user invited to matches when the filter is passed' do
          call_action(params: { invitations_by_user: user.id }, format: 'json')

          matches_data = JSON.parse(response.body)
          expect(response).to be_successful
          expect(Match.count).to eq(5)
          expect(matches_data.size).to eq(1)
          expect(matches_data.map do |match|
                   match['title']
                 end).to match_array(['Invitation Match'])
          expect(matches_data.map do |match|
                   match['id']
                 end).to match_array([invitation_match.id])
        end

        it 'is succesful when using all filter_scopes' do
          Match.filter_scopes.each do |filter|
            call_action(params: { filter => user.id })
            expect(response).to be_successful
          end
        end

        it 'redirect to 403 if user id is not current_user id' do
          Match.filter_scopes.each do |filter|
            call_action(params: { filter => another_user.id })
            expect(response).to redirect_to(unauthorized_path)
          end
        end
      end
    end
  end

  describe 'GET /show' do
    def call_action(match = create(:match, valid_params))
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

  describe 'POST /create' do
    def call_action(params = valid_params_with_creator_participates)
      post matches_url, params: { match: params }
    end

    it_behaves_like 'not_logged_in'

    context 'user authenticated' do
      before do
        sign_in(user)
      end

      context 'with valid parameters' do
        it 'creates a new Match notifying invited users' do
          expect_any_instance_of(MatchInvitationsManager)
            .to receive(:call).and_call_original

          expect do
            call_action
          end.to change(Match, :count).from(0).to(1)
                                      .and change(MatchParticipant, :count).from(0).to(1)
                                                                           .and have_enqueued_job(Noticed::DeliveryMethods::Email).twice

          expect(MatchParticipant.last.user).to eq(user)

          expect(response).to redirect_to(match_url(Match.last))
          expect(flash[:notice]).to eq('La partida ha sido creada con éxito.')

          created_match = Match.last
          expect(created_match.title).to eq('Testing matches')
          expect(created_match.description).to eq('I hope they pass.')
          expect(created_match.creator).to eq(user)
          expect(created_match.game).to eq(game)
          expect(created_match.location).to eq('my place')
          expect(created_match.number_of_players).to eq(3)
          expect(created_match.invited_users).to match_array(invited_users.pluck(:username))
          expect(created_match.start_at).to eq('2021-11-24 18:09:43')
          expect(created_match.end_at).to eq('2021-11-24 18:09:43')
          expect(created_match.public).to eq(false)
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

      it 'redirects to root if current user is not the creator' do
        another_user = create(:user, :confirmed)
        match = create(:match, user: another_user)

        call_action(match)

        expect(response).to redirect_to(unauthorized_path)
      end
    end
  end

  describe 'PATCH /update' do
    let(:match) { create(:match, set_params({ title: 'Old title', invited_users: invited_users.pluck(:username) })) }

    def call_action(params = valid_params_with_creator_participates)
      patch match_url(match), params: { match: params }
    end

    it_behaves_like 'not_logged_in'

    context 'user authenticated' do
      before { sign_in(user) }

      context 'with valid parameters' do
        let!(:another_user) { create(:user, :confirmed, username: 'another_user') }
        let(:new_params) do
          set_params({ title: 'New title',
                       invited_users: "#{valid_params[:invited_users]} another_user",
                       public: true })
        end

        it 'updates the requested match' do
          # We create the existing invitations before the update was done.
          create(:match_invitation, match: match, user: invited_users.first)
          create(:match_invitation, match: match, user: invited_users.last)

          expect(match.title).to eq('Old title')
          expect_any_instance_of(MatchInvitationsManager)
            .to receive(:call).and_call_original

          expect do
            call_action(new_params)
          end.not_to change(MatchParticipant, :count)

          expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq(1)
          expect(ActiveJob::Base.queue_adapter.enqueued_jobs.last['job_class'])
            .to eq('Noticed::DeliveryMethods::Email')

          match.reload
          expect(match.title).to eq('New title')
          expect(match.invited_users)
            .to match_array(invited_users.pluck(:username) + ['another_user'])
          expect(match.public).to eq(true)
          expect(response).to redirect_to(match_url(match))
        end

        it 'redirects to root if current user is not the creator' do
          sign_out(user)
          another_user = create(:user, :confirmed)
          sign_in(another_user)

          expect(match.title).to eq('Old title')

          call_action(new_params)

          match.reload
          expect(match.title).to eq('Old title')
          expect(response).to redirect_to(unauthorized_path)
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
