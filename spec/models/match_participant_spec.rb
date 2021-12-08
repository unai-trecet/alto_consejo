require 'rails_helper'

RSpec.describe MatchParticipant, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:match) }

  describe 'match_creator' do
    let(:match) { create(:match) }
    subject { create(:match_participant, match: match) }

    it 'return the creator of the match' do
      expect(subject.match_creator).to eq(match.user)
    end
  end
end
