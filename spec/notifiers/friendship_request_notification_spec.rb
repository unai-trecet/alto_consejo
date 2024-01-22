require 'rails_helper'

RSpec.describe FriendshipRequestNotification, type: :notification do
  let(:user) { create(:user, :confirmed) }
  let(:friendship) { create(:friendship, user: user) }
  let(:notification) { described_class.with(friendship: friendship, sender: user) }

  describe '#message' do
    it 'returns the expected message' do
      expect(notification.message).to eq("Has recibido una solicitud de amistad de @#{user.username}")
    end
  end

  describe '#url' do
    it 'returns the expected URL' do
      expect(notification.url).to eq(friendship_url(friendship))
    end
  end

  describe 'delivery methods' do
    let(:recipient) { user }

    it 'delivers the notification via email' do
      perform_enqueued_jobs do
        expect { notification.deliver(recipient) }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq('Tienes una solicitud de amistad!')
      expect(mail.to).to include(recipient.email)
    end
  end
end