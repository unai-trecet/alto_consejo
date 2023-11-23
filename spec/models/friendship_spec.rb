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

  describe '.already_exists?' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    context 'when a friendship already exists' do
      before do
        Friendship.create(user:, friend:)
      end

      it 'returns true if the user_id and friend_id are the same' do
        expect(Friendship.already_exists?(user_id: user.id, friend_id: friend.id)).to be true
      end

      it 'returns true if the user_id and friend_id are swapped' do
        expect(Friendship.already_exists?(user_id: friend.id, friend_id: user.id)).to be true
      end
    end

    context 'when a friendship does not exist' do
      it 'returns false' do
        expect(Friendship.already_exists?(user_id: user.id, friend_id: friend.id)).to be false
      end
    end
  end
end
