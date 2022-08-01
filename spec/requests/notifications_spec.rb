# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/notifications', type: :request do
  let(:user) { create(:user, :confirmed) }

  let(:valid_attributes) do
    { recipient: user,
      type: 'MatchInvitationNotification',
      params: { match: create(:match, user: create(:user, username: 'testingnotifications')) },
      read_at: nil }
  end

  let(:invalid_attributes) do
    valid_attributes.merge(recipient: nil)
  end

  describe 'GET /index' do
    def call_action
      get notifications_url
    end

    it_behaves_like 'not_logged_in'

    context 'authenticated' do
      before { sign_in(user) }

      it 'renders only notifications belong current_user' do
        match1 = create(:match, user: create(:user, username: 'darklidia'))
        match2 = create(:match, user: create(:user, username: 'tempestus'))

        create(:notification, :match_invitation_notification, params: { match: match1 }, recipient: user)
        create(:notification, :match_invitation_notification, params: { match: match2 }, recipient: user)

        match3 = create(:match, user: create(:user, username: 'mynemesis'))
        create(:notification, :match_invitation_notification, params: { match: match3 })

        call_action

        expect(response).to be_successful
        expect(response.body).to include('Has sido invitado/a a una partida organizada por @darklidia')
        expect(response.body).to include('Has sido invitado/a a una partida organizada por @tempestus')
        expect(response.body).not_to include('Has sido invitado/a a una partida organizada por @mynemesis')
      end
    end
  end

  describe 'GET /show' do
    let(:notification) do
      create(:notification,
             :match_invitation_notification,
             valid_attributes)
    end

    def call_action
      get notification_url(notification)
    end

    it_behaves_like 'not_logged_in'

    context 'authenticated' do
      before { sign_in(user) }

      it 'renders a successful response' do
        call_action

        expect(response.body).to include('Has sido invitado/a a una partida organizada por @testingnotifications')
        expect(response).to be_successful
      end

      it 'sets notification as read' do
        call_action

        notification.reload
        expect(notification.read?).to eq(true)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:notification) { create(:notification, :match_invitation_notification, valid_attributes) }

    def call_action
      delete notification_url(notification)
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before { sign_in(user) }

      it 'destroys the requested notification' do
        expect do
          call_action
        end.to change(Notification, :count).from(1).to(0)
      end

      it 'redirects to the notifications list' do
        call_action

        expect(response).to redirect_to(notifications_url)
      end
    end
  end
end
