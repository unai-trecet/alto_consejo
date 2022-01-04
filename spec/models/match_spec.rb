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

    describe '.public' do
      it 'returns only passed matches' do
        public_match1 = create(:match, public: true)
        public_match2 = create(:match, public: true)
        create(:match, public: false)

        expect(Match.open).to match_array([public_match1, public_match2])
      end
    end

    describe '.played' do
      it 'returns only passed matches' do
        played_match1 = create(:match, end_at: DateTime.now - 1.day)
        played_match2 = create(:match, end_at: DateTime.now - 2.day)
        create(:match, end_at: DateTime.now + 1.minute)
        create(:match, end_at: DateTime.now + 1.day)

        expect(Match.played).to match_array([played_match1, played_match2])
      end
    end

    describe '.not_played' do
      it 'returns only passed matches' do
        create(:match, end_at: DateTime.now - 1.day)
        create(:match, end_at: DateTime.now - 2.day)
        not_played_match1 = create(:match, end_at: DateTime.now + 1.minute)
        not_played_match2 = create(:match, end_at: DateTime.now + 1.day)

        expect(Match.not_played).to match_array([not_played_match1, not_played_match2])
      end
    end
  end
end
