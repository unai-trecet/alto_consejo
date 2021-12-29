# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchParticipant, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:match) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:match_id) }

  it 'validates uniqueness of combined user and match' do
    create(:match_participant)
    should validate_uniqueness_of(:user_id).scoped_to(:match_id)
  end

  describe 'match_creator' do
    let(:match) { create(:match) }
    subject { create(:match_participant, match: match) }

    it 'return the creator of the match' do
      expect(subject.match_creator).to eq(match.user)
    end
  end
end
