require 'rails_helper'

RSpec.describe FriendshipsCreationManager do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }

  subject { described_class.new(user_id: user.id, friend_id: friend.id) }

  describe '#call' do
    context 'when friendship already exists' do
      before do
        create(:friendship, user:, friend:)
      end

      it 'returns a result with success: false' do
        result = subject.call
        expect(result.success).to be false
        expect(result.error).to include 'already exists'
      end
    end

    context 'when friendship does not exist' do
      let(:notification) { instance_double(ActionMailer::MessageDelivery) }

      before do
        allow(FriendshipRequestNotification).to receive(:with).and_return(notification)
        allow(notification).to receive(:deliver_later)
      end

      it 'creates a new friendship and sends a notification' do
        expect { subject.call }.to change { Friendship.count }.by(1)
        expect(FriendshipRequestNotification).to have_received(:with).with(friendship: kind_of(Friendship))
        expect(notification).to have_received(:deliver_later)
      end

      it 'returns a result with success: true' do
        result = subject.call
        expect(result.success).to be true
      end
    end
  end
end
