require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:comment) { create(:comment, user: user) }

    context 'when the user is authorized' do
      before do
        sign_in(user)
        delete :destroy, params: { id: comment.id }
      end

      it 'deletes the comment' do
        expect(Comment.exists?(comment.id)).to be_falsey
      end

      it 'redirects to the commentable resource' do
        expect(response).to redirect_to(comment.commentable)
      end

      it 'responds with a 302 status code' do
        expect(response).to have_http_status(302)
      end
    end

    context 'when the user is not authorized' do
      before do
        delete :destroy, params: { id: comment.id }
      end

      it 'sets a flash notice' do
        expect(flash[:notice]).to eq('You are not authorized to delete this comment.')
      end

      it 'responds with a 401 status code' do
        expect(response).to have_http_status(401)
      end
    end
  end
end