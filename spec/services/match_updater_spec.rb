# spec/services/match_updater_spec.rb
require 'rails_helper'

RSpec.describe MatchUpdater, type: :service do
  let(:user) { create(:user) }
  let(:match) { create(:match, user:) }
  let(:match_params) do
    {
      title: 'Updated Match',
      description: 'Updated Description',
      user_id: user.id,
      game_id: match.game.id,
      location: 'Updated Location',
      number_of_players: 5,
      start_at: Time.now + 1.hour,
      end_at: Time.now + 2.hours,
      public: true,
      invited_users: 'user1,user2',
      creator_participates: true
    }
  end

  subject { described_class.new(match, match_params) }

  describe '#call' do
    context 'when match is successfully updated' do
      it 'updates the match' do
        subject.call
        match.reload
        expect(match.title).to eq(match_params[:title])
        expect(match.description.body.to_plain_text).to eq(match_params[:description])
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

    context 'when match is not updated' do
      before do
        match_params[:title] = nil # invalid match
      end

      it 'does not update the match' do
        subject.call
        match.reload
        expect(match.title).not_to eq(match_params[:title])
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
