# spec/services/match_creator_spec.rb
require 'rails_helper'

RSpec.describe MatchCreator, type: :service do
  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let(:match_params) do
    {
      title: 'Test Match',
      description: 'Test Description',
      user_id: user.id,
      game_id: game.id,
      location: 'Test Location',
      number_of_players: 5,
      start_at: Time.now + 1.hour,
      end_at: Time.now + 2.hours,
      public: true,
      invited_users: 'user1,user2',
      creator_participates: true
    }
  end

  subject { described_class.new(match_params, user) }

  describe '#call' do
    context 'when match is successfully created' do
      it 'creates a new match' do
        expect { subject.call }.to change(Match, :count).by(1)
      end

      it 'calls MatchParticipationManager' do
        expect(MatchParticipationManager).to receive(:new).and_call_original
        subject.call
      end

      it 'calls MatchInvitationsManager' do
        expect(MatchInvitationsManager).to receive(:new).and_call_original
        subject.call
      end
    end

    context 'when match is not created' do
      before do
        match_params[:title] = nil  # invalid match
      end

      it 'does not create a new match' do
        expect { subject.call }.not_to change(Match, :count)
      end

      it 'does not call MatchParticipationManager' do
        expect(MatchParticipationManager).not_to receive(:new)
        subject.call
      end

      it 'does not call MatchInvitationsManager' do
        expect(MatchInvitationsManager).not_to receive(:new)
        subject.call
      end
    end
  end
end