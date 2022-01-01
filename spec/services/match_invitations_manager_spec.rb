# frozen_string_literal: true

RSpec.describe MatchInvitationsManager do
  describe '#call' do
    let(:creator) { create(:user, :confirmed) }
    let!(:invited_users) { create_list(:user, 2) }
    let(:match) { create(:match, user: creator, invited_users: invited_users.pluck(:username)) }

    context 'with creator participating in the match' do
      subject do
        described_class
          .new(creator_participates: true,
               match: match)
      end

      it 'creates expected match_invitations' do
        expect do
          subject.call
        end.to change(MatchInvitation, :count).from(0).to(2)

        expect(MatchInvitation.all.map(&:user)).to match_array(invited_users)
        expect(MatchInvitation.all.map(&:match)).to match_array([match, match])
      end

      it 'does not create new match_invitations if they already exists' do
        create(:match_invitation, user: invited_users.first, match: match)
        create(:match_invitation, user: invited_users.last, match: match)

        expect do
          subject.call
        end.not_to change(MatchInvitation, :count)
      end

      it 'does not send notifications if the invitations already existed' do
        create(:match_invitation, user: invited_users.first, match: match)
        create(:match_invitation, user: invited_users.last, match: match)

        expect do
          subject.call
        end.not_to have_enqueued_job(Noticed::DeliveryMethods::Email)
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

    context 'creator is not participating' do
      subject { described_class.new(match: match, creator_participates: false) }

      it 'only sends email to invited users and creates invitations' do
        expect(MatchInvitationNotification)
          .to receive(:with).with(match: match)
                            .and_call_original

        expect do
          subject.call
        end.to have_enqueued_job(Noticed::DeliveryMethods::Email).twice
                                                                 .and change(MatchInvitation, :count).from(0).to(2)

        expect(MatchParticipant.count).to eq(0)
      end
    end

    context 'creator participation already exist' do
      subject do
        described_class
          .new(creator_participates: true,
               match: match)
      end

      it 'only sends email to invited users' do
        create(:match_participant, user: creator, match: match)

        expect(MatchInvitationNotification)
          .to receive(:with).with(match: match)
                            .and_call_original

        expect do
          subject.call
        end.to have_enqueued_job(Noticed::DeliveryMethods::Email).twice

        expect(MatchParticipant.count).to eq(1)
        expect(MatchParticipant.last.user).to eq(creator)
      end
    end
  end
end
