require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:game) }
  end

  describe 'validations' do
    let(:user) { create(:user) }
    let(:game) { create(:game) }
    subject { build(:review, user:, game:) }

    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:content) }
    it {
      should validate_uniqueness_of(:user_id).scoped_to(:game_id).with_message('Solo se puede revisar un juego una vez')
    }
  end
end
