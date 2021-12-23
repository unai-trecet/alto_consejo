# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Match, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:game) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:start_at) }
  it { should validate_presence_of(:end_at) }

  describe 'scopes' do
    describe '.played' do
      it 'returns only passed matches' do
        match_played_1 = create(:match, end_at: DateTime.now - 1.day)
        match_played_2 = create(:match, end_at: DateTime.now - 2.day)
        create(:match, end_at: DateTime.now + 1.minute)
        create(:match, end_at: DateTime.now + 1.day)

        expect(Match.played.count).to eq(2)
        expect(Match.played.pluck(:id)).to match_array([match_played_1.id, match_played_2.id])
      end
    end

    describe '.not_played' do
      it 'returns only passed matches' do
        create(:match, end_at: DateTime.now - 1.day)
        create(:match, end_at: DateTime.now - 2.day)
        not_match_played_1 = create(:match, end_at: DateTime.now + 1.minute)
        not_match_played_2 = create(:match, end_at: DateTime.now + 1.day)

        expect(Match.not_played.count).to eq(2)
        expect(Match.not_played.pluck(:id)).to match_array([not_match_played_1.id, not_match_played_2.id])
      end
    end
  end
end
