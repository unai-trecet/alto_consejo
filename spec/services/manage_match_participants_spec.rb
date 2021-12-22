# frozen_string_literal: true

RSpec.describe ManageMatchParticipants do
  describe '#call' do
    let(:creator) { create(:user, :confirmed) }
    let!(:invited_users) { create_list(:user, 2) }
    let!(:invited_usernames) { invited_users.pluck(:username) }
    let(:match) { create(:match, user: creator) }

    context 'with creator participating in the match' do
      subject do
        described_class
          .new(creator: creator, invited_usernames: invited_usernames, match: match)
      end

      it 'triggers invited users notifications' do
        expect(MatchInvitationNotification)
          .to receive(:with).with(match: match)
                            .and_call_original

        expect do
          subject.call
        end.to have_enqueued_job(Noticed::DeliveryMethods::Email).twice
      end

      it 'sets creator as participant of the match' do
        expect do
          subject.call
        end.to change(MatchParticipant, :count).from(0).to(1)

        expect(MatchParticipant.last.user).to eq(creator)
      end
    end

    context 'creator is not participating' do
      subject { described_class.new(invited_usernames: invited_usernames, match: match) }

      it 'only sends email to invited users' do
        expect(MatchInvitationNotification)
          .to receive(:with).with(match: match)
                            .and_call_original

        expect do
          subject.call
        end.to have_enqueued_job(Noticed::DeliveryMethods::Email).twice

        expect(MatchParticipant.count).to eq(0)
      end
    end
  end
end
