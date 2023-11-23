# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendshipsController, type: :request do
  let(:user) { create(:user, :confirmed) }
  let(:friend) { create(:user, :confirmed) }
  let(:friendship) { create(:friendship, user:, friend:) }

  describe 'POST #create' do
    def call_action(params = {})
      params = { user_id: user.id, friend_id: friend.id }.merge(params)
      post '/friendships', params:
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before do
        sign_in user
      end

      context 'with valid parameters' do
        it 'creates a new friendship' do
          expect do
            call_action
          end.to change(Friendship, :count).by(1)
          expect(response).to be_successful
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new friendship' do
          manager = instance_double(FriendshipsCreationManager)
          allow(FriendshipsCreationManager).to receive(:new).and_return(manager)
          allow(manager).to receive(:call).and_return(double(success?: false, errors: ['error']))

          expect do
            call_action({ user_id: nil, friend_id: nil })
          end.not_to change(Friendship, :count)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  xdescribe 'PATCH #update' do
    def call_action
      patch "/friendships/#{friendship.id}", params: { user_id: user.id, friend_id: friend.id }
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before { sign_in user }

      context 'with valid parameters' do
        it 'updates the requested friendship' do
          call_action
          friendship.reload
          expect(friendship.user).to eq(user)
          expect(friendship.friend).to eq(friend)
        end

        it 'redirects to the friendship' do
          call_action
          expect(response).to redirect_to(friendship_url(friendship))
        end
      end

      context 'with invalid parameters' do
        it 'does not update the friendship' do
          patch "/friendships/#{friendship.id}", params: { user_id: nil, friend_id: nil }
          friendship.reload
          expect(friendship.user).not_to be_nil
          expect(friendship.friend).not_to be_nil
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    def call_action(friendship = create(:friendship))
      delete friendship_url(friendship)
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before { sign_in user }

      it 'destroys the requested friendship' do
        friendship
        expect do
          call_action(friendship)
        end.to change(Friendship, :count).by(-1)
        expect(response).to be_successful
      end
    end
  end
end
