require 'rails_helper'

RSpec.describe GamesHelper, type: :helper do
  describe '#can_edit_game?' do
    let(:user) { create(:user, :confirmed) }
    let(:admin) { create(:user, :admin) }
    let(:game) { Game.new(user:) }

    context 'when the user can edit the game' do
      it 'returns true' do
        allow(helper).to receive(:current_user).and_return(user)
        allow(helper).to receive(:admin?).and_return(false)
        assign(:game, game)

        expect(helper.can_edit_game?).to be true
      end
    end

    context 'when the user cannot edit the game' do
      it 'returns false' do
        allow(helper).to receive(:current_user).and_return(User.new)
        allow(helper).to receive(:admin?).and_return(false)
        assign(:game, game)

        expect(helper.can_edit_game?).to be false
      end
    end
  end
end
