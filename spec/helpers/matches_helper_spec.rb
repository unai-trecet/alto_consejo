# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchesHelper, type: :helper do
  let(:user) { create(:user, :confirmed, username: 'sure_invited') }
  let(:admin) { create(:user, :admin) }

  before { sign_in(user) }

  describe 'can_participate?' do
    it 'returns true if current_user is among match invited_users' do
      assign(:match, create(:match, invited_users: [user.username]))

      expect(helper.can_participate?).to eq(true)
    end

    it 'returns false if current_user is not among match invited_users' do
      assign(:match, create(:match, user:))

      expect(helper.can_participate?).to eq(false)
    end
  end

  describe 'already_participating?' do
    it 'returns true if current_user is a match participant' do
      match = create(:match, invited_users: [user.username])
      assign(:match, match)
      create(:match_participant, user:, match:)

      expect(helper.already_participating?).to eq(true)
    end

    it 'returns false if current_user is not yet a match participant' do
      assign(:match, create(:match))

      expect(helper.already_participating?).to eq(false)
    end
  end

  describe '#can_edit_match?' do
    it 'returns true if current user is the match creator' do
      match = create(:match, user:)
      assign(:match, match)

      allow(helper).to receive(:current_user).and_return(user)
      expect(helper.can_edit_match?).to be true
    end

    it 'returns true if current user is an admin' do
      match = create(:match)
      assign(:match, match)

      allow(helper).to receive(:admin?).and_return(true)
      expect(helper.can_edit_match?).to be true
    end
  end
end
