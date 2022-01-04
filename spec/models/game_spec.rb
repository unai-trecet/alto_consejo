# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  subject { create(:game) }

  let(:played_match) { create(:match, game: subject, end_at: 1.hour.ago) }
  let(:future_match) { create(:match, game: subject, end_at: 1.hour.since) }

  it { should belong_to(:user) }

  it { should have_many(:matches) }
  it {
    should have_many(:played_matches)
      .conditions("end_at < #{DateTime.now}")
      .class_name('Match')
  }
  it {
    should have_many(:planned_matches)
      .conditions("end_at > #{DateTime.now}")
      .class_name('Match')
  }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  describe '#played_matches' do
    it 'returns only passed matches' do
      expect(subject.played_matches).to match_array([played_match])
    end
  end

  describe '#planned_matches' do
    it 'returns only future matches' do
      expect(subject.planned_matches).to match_array([future_match])
    end
  end

  describe '#players' do
    it 'returns users who have played at least one played match' do
      player1 = create(:user, :confirmed)
      player2 = create(:user, :confirmed)
      player3 = create(:user, :confirmed)

      played_match2 = create(:match, game: subject, end_at: 1.hour.ago)

      create(:match_participant, user: player1, match: played_match)
      create(:match_participant, user: player2, match: played_match)
      create(:match_participant, user: player1, match: played_match2)

      create(:match_participant, user: player3, match: future_match)

      expect(subject.players).to match_array([player1, player2])
    end
  end
end
