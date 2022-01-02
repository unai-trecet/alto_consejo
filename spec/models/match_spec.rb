# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Match, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:game) }

  it { should have_many(:match_participants) }
  it {
    should have_many(:participants)
      .through(:match_participants)
      .source(:user)
  }

  it { should have_many(:match_invitations) }
  it {
    should have_many(:invitees)
      .through(:match_invitations)
      .source(:user)
  }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:start_at) }
  it { should validate_presence_of(:end_at) }

  describe 'scopes' do
    describe '.played' do
      it 'returns only passed matches' do
        played_match1 = create(:match, end_at: DateTime.now - 1.day)
        played_match2 = create(:match, end_at: DateTime.now - 2.day)
        create(:match, end_at: DateTime.now + 1.minute)
        create(:match, end_at: DateTime.now + 1.day)

        expect(Match.played.count).to eq(2)
        expect(Match.played.pluck(:id)).to match_array([played_match1.id, played_match2.id])
      end
    end

    describe '.not_played' do
      it 'returns only passed matches' do
        create(:match, end_at: DateTime.now - 1.day)
        create(:match, end_at: DateTime.now - 2.day)
        not_played_match_1 = create(:match, end_at: DateTime.now + 1.minute)
        not_played_match_2 = create(:match, end_at: DateTime.now + 1.day)

        expect(Match.not_played.count).to eq(2)
        expect(Match.not_played.pluck(:id)).to match_array([not_played_match_1.id, not_played_match_2.id])
      end
    end
  end
end
