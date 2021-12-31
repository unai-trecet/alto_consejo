# frozen_string_literal: true

RSpec.describe MatchParticipationManager do
  let(:player) { create(:user, :confirmed) }
  let(:creator) { create(:user, :confirmed) }
  let(:match) { create(:match, user: creator) }

  describe '#call' do
    subject { described_class.new(user_id: player.id, match_id: match.id) }

    it 'creates a match_participant' do
      result = {}
      expect do
        result = subject.call
      end.to change(MatchParticipant, :count).from(0).to(1)
      participation = MatchParticipant.last

      expect(participation.user).to eq(player)
      expect(participation.match).to eq(match)
      expect(result).to eq({ participation: participation, errors: [] })
    end

    it 'does not create another match_participant if it exists' do
      create(:match_participant, user: player, match: match)
      expect(MatchParticipant.count).to eq(1)
      result = {}
      expect do
        result = subject.call
      end.not_to change(MatchParticipant, :count)
      participation = MatchParticipant.last

      expect(result).to eq({ participation: participation, errors: [] })
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

    it 'does nothing if notification fails' do
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

      result = {}
      expect do
        result = subject.call
      end.not_to have_enqueued_job(Noticed::DeliveryMethods::Email)

      expect(MatchParticipant.count).to eq(0)
      expect(MatchInvitation.count).to eq(1)
      expect(result).to eq({ participation: nil, errors: ['Noticed::ValidationError'] })
    end

    it 'does nothing if recording fails' do
      allow(MatchParticipant)
        .to receive(:first_or_create!).and_wrap_original do |method, args|
        args[:user_id] = nil
        method.call(args)
      end

      result = {}
      expect do
        result = subject.call
      end.not_to have_enqueued_job(Noticed::DeliveryMethods::Email)

      expect(MatchParticipant.count).to eq(0)
      expect(MatchInvitation.count).to eq(0)
      expect(result).to eq({ participation: nil,
                             errors: ['La validación falló: User debe existir, User no puede estar en blanco'] })
    end
  end
end
