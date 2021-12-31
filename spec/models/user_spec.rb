# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }

  it { should validate_uniqueness_of(:email) }
  it { should validate_uniqueness_of(:username) }

  it { should have_many(:notifications) }
  it { should have_many(:games) }
  it { should have_many(:matches) }
  it { should have_many(:match_participants) }
  it {
    should have_many(:participations)
      .through(:match_participants)
      .source(:match)
  }
  it { should have_many(:match_invitations) }
  it {
    should have_many(:invitations)
      .through(:match_invitations)
      .source(:match)
  }

  describe '#played_matches' do
    subject { create(:user, :confirmed) }

    it 'returns only passed matches' do
      played_match = create(:match, end_at: 1.hour.ago)
      future_match = create(:match, end_at: 1.hour.since)
      create(:match_participant, user: subject, match: played_match)
      create(:match_participant, user: subject, match: future_match)

      expect(subject.played_matches).to match_array([played_match])
    end
  end
end
