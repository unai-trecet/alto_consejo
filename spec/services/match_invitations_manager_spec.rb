# frozen_string_literal: true

RSpec.describe MatchInvitationsManager do
  describe '#call' do
    let(:creator) { create(:user, :confirmed) }
    let!(:invited_users) { create_list(:user, 2) }
    let(:match) do
      create(:match, user: creator,
                     invited_users: invited_users.pluck(:username))
    end

    context 'with creator participating in the match' do
      subject do
        described_class.new(match:, sender: creator)
      end

      it 'creates expected match_invitations' do
        expect do
          subject.call
        end.to change(MatchInvitation, :count).from(0).to(2)

        expect(MatchInvitation.all.map(&:user)).to match_array(invited_users)
        expect(MatchInvitation.all.map(&:match)).to match_array([match, match])
      end

      it 'does not create new match_invitations if they already exists' do
        create(:match_invitation, user: invited_users.first, match:)
        create(:match_invitation, user: invited_users.last, match:)

        expect do
          subject.call
        end.not_to change(MatchInvitation, :count)
      end

      it 'does not send notifications if the invitations already existed' do
        create(:match_invitation, user: invited_users.first, match:)
        create(:match_invitation, user: invited_users.last, match:)

        expect do
          subject.call
        end.not_to have_enqueued_job(Noticed::DeliveryMethods::Email)
      end

      it 'does nothing if no users were invited' do
        match = create(:match, user: creator, invited_users: [])

        subject = described_class.new(match:, sender: creator)
        expect do
          subject.call
        end.not_to have_enqueued_job(Noticed::DeliveryMethods::Email)
      end

      it 'triggers invited users notifications' do
        expect(MatchInvitationNotification)
          .to receive(:with).with(match:, sender: creator)
                            .and_call_original

        expect do
          subject.call
        end.to have_enqueued_job(Noticed::DeliveryMethods::Email).twice
      end

      it 'does nothing if something fails' do
        # We make MatchInvitationNotification fail to raise a
        # Noticed::ValidationError exception.
        allow(MatchInvitationNotification)
          .to receive(:with).and_wrap_original do |method, args|
          args[:match] = nil
          method.call(args)
        end

        # We ommit the prevvious raised exception with suppress in order
        # to test the transaction block.
        suppress(Noticed::ValidationError) do
          expect do
            subject.call
          end.not_to have_enqueued_job(Noticed::DeliveryMethods::Email)
        end

        expect(MatchInvitation.count).to eq(0)
        expect(MatchParticipant.count).to eq(0)
      end
    end
  end
end
