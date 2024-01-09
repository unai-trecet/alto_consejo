require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#admin?' do
    context 'when current_user is an admin' do
      let(:current_user) { create(:user, :admin) }

      it 'returns true' do
        allow(helper).to receive(:current_user).and_return(current_user)
        expect(helper.admin?).to be true
      end
    end

    context 'when current_user is not an admin' do
      let(:current_user) { create(:user, :confirmed) }

      it 'returns false' do
        allow(helper).to receive(:current_user).and_return(current_user)
        expect(helper.admin?).to be false
      end
    end
  end
end
