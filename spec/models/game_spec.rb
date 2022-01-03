# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:matches) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  describe '#played_matches' do
    subject { create(:game) }

    it 'returns only passed matches' do
      played_match = create(:match, game: subject, end_at: 1.hour.ago)
      _future_match = create(:match, game: subject, end_at: 1.hour.since)

      expect(subject.played_matches).to match_array([played_match])
    end
  end
end
