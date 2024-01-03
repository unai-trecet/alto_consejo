# spec/requests/likes_controller_spec.rb
require 'rails_helper'

RSpec.describe LikesController, type: :request do
  let(:user) { create(:user, :confirmed) }
  let(:likeable) { create(:comment) } # replace :comment with your likeable model

  describe 'PATCH #like' do
    it_behaves_like 'not_logged_in'

    def call_action
      patch like_url(likeable_type: likeable.class.name, likeable_id: likeable.id)
    end

    context 'when authenticated' do
      before do
        sign_in user
      end

      context 'when user has not liked the likeable' do
        it 'likes the likeable' do
          expect do
            call_action
          end.to change { user.voted_up_on?(likeable) }.from(false).to(true)
        end
      end

      context 'when user has already liked the likeable' do
        before do
          likeable.upvote_by(user)
        end

        it 'unlikes the likeable' do
          expect do
            call_action
          end.to change { user.voted_up_on?(likeable) }.from(true).to(false)
        end
      end
    end
  end
end
