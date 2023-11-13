# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:friend).class_name('User') }

  it { should validate_presence_of(:friend) }
  it { should validate_presence_of(:user) }

  describe 'scopes' do
    let(:friendship1) { create(:friendship, accepted_at: Time.now) }
    let(:friendship2) { create(:friendship, accepted_at: Time.now) }
    let(:friendship3) { create(:friendship, accepted_at: nil) }

    describe 'accepted' do
      it 'returns only accepted friendships' do
        expect(Friendship.accepted).to match_array([friendship1, friendship2])
      end
    end

    describe 'pending' do
      it 'returns only not yet accepted friendships' do
        expect(Friendship.pending).to match_array([friendship3])
      end
    end
  end
end
