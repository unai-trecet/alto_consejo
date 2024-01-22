require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  let(:user) { create(:user, :confirmed) }
  let(:notification) { MatchInvitationNotification.with(match: create(:match), sender: user).deliver(user) }

  before do
    sign_in user
  end

  describe 'GET /index' do
    it 'returns a successful response' do
      get notifications_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'returns a successful response' do
      get notification_url(notification)
      expect(response).to be_successful
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested notification and redirects' do
      delete notification_url(notification)
      expect(response).to redirect_to(notifications_url)
    end
  end
end
