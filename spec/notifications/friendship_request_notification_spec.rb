require 'rails_helper'

RSpec.describe FriendshipRequestNotification, type: :notification do
  let(:user) { create(:user) }
  let(:friendship) { create(:friendship, user:) }
  let(:notification) { described_class.with(friendship:, sender: user) }

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
    let(:recipient) { create(:user) }
  
    before do
      notification.deliver(recipient)
    end
  
    it 'delivers the notification to the database' do
      expect(Notification.exists?(recipient: recipient)).to be true
    end
  
    it 'delivers the notification via email' do
      expect { notification.deliver(recipient) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  
    it 'uses the FriendshipRequestMailer to send the email' do
      expect(FriendshipRequestMailer)
        .to receive(:with)
        .and_call_original
      notification.deliver(recipient)
    end
  end
end
