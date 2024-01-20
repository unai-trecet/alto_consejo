# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/comments', type: :request do
  let(:user) { create(:user, :confirmed) }
  let(:another_user) { create(:user, :confirmed) }

  def valid_attributes(input = {})
    {
      body: 'Testing comments controller.',
      user:
    }.merge(input)
  end

  let(:invalid_attributes) do
    { body: '' }
  end

  describe 'GET /show' do
    def call_action(comment = create(:comment, user:))
      get comment_url(comment)
    end

    it_behaves_like 'not_logged_in'

    it 'renders a successful response' do
      sign_in user
      comment = create(:comment, valid_attributes)

      call_action(comment)

      expect(response).to be_successful
      expect(response).to render_template(:show)
    end
  end

  describe 'GET /edit' do
    def call_action(comment = create(:comment))
      get edit_comment_url(comment)
    end

    it_behaves_like 'not_logged_in'

    it 'renders a successful response' do
      sign_in user
      comment = create(:comment, valid_attributes)

      call_action(comment)

      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end

    it 'does not render edit for another user\'s comment' do
      comment = create(:comment, valid_attributes({ user: another_user }))

      call_action(comment)

      expect(response).not_to render_template(:edit)
      expect(response).to have_http_status(302)
    end
  end

  describe 'PATCH /update' do
    def call_action(comment = create(:comment), params = { comment: valid_attributes })
      patch comment_url(comment), params:
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before { sign_in user }
      context 'with valid parameters' do
        let(:new_attributes) do
          { body: 'Updating content.' }
        end

        it 'updates the requested comment' do
          comment = create(:comment, valid_attributes)

          call_action(comment, { comment: new_attributes })

          comment.reload
          expect(comment.body.body.as_json).to eq('Updating content.')
        end

        context 'when the user is not the owner of the comment' do
          let(:comment) { create(:comment, valid_attributes({ user: another_user })) }

          before { call_action(comment, { comment: new_attributes }) }

          it 'does not update another user\'s comment' do
            comment.reload
            expect(comment.body.body.as_json).to eq('Testing comments controller.')
          end

          it 'returns an unauthorized status' do
            expect(response).to redirect_to(unauthorized_path)
          end
        end

        context 'with invalid parameters' do
          it "renders a successful response (i.e. to display the 'edit' template)" do
            comment = create(:comment, valid_attributes)

            call_action(comment, { comment: invalid_attributes })

            expect(response.status).to eq(422)
            expect(response).to render_template(:edit)
          end
        end
      end
    end
  end

  describe 'DELETE /comments/:id' do
    let(:other_user) { FactoryBot.create(:user, :confirmed) }
    let(:user_comment) { FactoryBot.create(:comment, user:) }

    def call_action(comment = user_comment)
      delete comment_url(comment)
    end

    it_behaves_like 'not_logged_in'

    context 'when the user is authorized' do
      context 'when the user is the owner of the comment' do
        before do
          sign_in user
          call_action
        end

        it 'deletes the comment' do
          expect(Comment.exists?(user_comment.id)).to be_falsey
        end

        it 'redirects to the commentable' do
          expect(response).to redirect_to(user_comment.commentable)
        end
      end

      context 'when the user is not the owner of the comment' do
        before do
          sign_in other_user
          call_action
        end

        it 'does not delete the comment' do
          expect(Comment.exists?(user_comment.id)).to be_truthy
        end

        it 'returns an unauthorized status' do
          expect(response).to redirect_to(unauthorized_path)
        end
      end
    end
  end
end
