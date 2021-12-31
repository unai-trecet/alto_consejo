# frozen_string_literal: true

RSpec.describe MatchParticipationManager do
  let(:player) { create(:user, :confirmed) }
  let(:creator) { create(:user, :confirmed) }
  let(:match) { create(:match, user: creator) }

  describe '#call' do
    subject { described_class.new(user_id: player.id, match_id: match.id) }

    it 'creates a match_participant' do
      expect do
        subject.call
      end.to change(MatchParticipant, :count).from(0).to(1)
      participation = MatchParticipant.last

      expect(participation.user).to eq(player)
      expect(participation.match).to eq(match)
    end

    it 'deletes a match_invitation if exists' do
      create(:match_invitation, user: player, match: match)
      expect do
        subject.call
      end.to change(MatchInvitation, :count).from(1).to(0)
    end

    it 'sends notidifications to participants except the one joining' do
      participants = create_list(:user, 2, :confirmed)
      create(:match_participant, match: match, user: participants.first)
      create(:match_participant, match: match, user: participants.last)
      create(:match_participant, match: match, user: creator)

      recipients = participants.push(creator)

      expect(MatchParticipationNotification)
        .to receive(:with).with(match: match, player: player)
                          .and_call_original
      expect_any_instance_of(MatchParticipationNotification).to receive(:deliver_later)
        .with(recipients).and_call_original

      expect do
        subject.call
      end.to have_enqueued_job(Noticed::DeliveryMethods::Email).exactly(3).times
    end

    it 'does nothing if something fails' do
      # We create an reviously existing invitation for the player
      # that should not be deleted.
      create(:match_invitation, user: player, match: match)
      # We make MatchParticipationNotification fail to raise a
      # Noticed::ValidationError exception.
      allow(MatchParticipationNotification)
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

      expect(MatchParticipant.count).to eq(0)
      expect(MatchInvitation.count).to eq(1)
    end
  end
end
