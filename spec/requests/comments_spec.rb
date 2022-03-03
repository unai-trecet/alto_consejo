# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/comments', type: :request do
  let(:user) { create(:user, :confirmed) }
  let(:another_user) { create(:user, :confirmed) }
  
  def valid_attributes(input = {})
    {
      body: 'Testing comments controller.',
      user: user
    }.merge(input)
  end

  let(:invalid_attributes) do
    { body: '' }
  end

  describe 'GET /show' do
    def call_action(comment = create(:comment))
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
      patch comment_url(comment), params: params
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

        it 'does not update another user\'s comment' do
          comment = create(:comment, valid_attributes({ user: another_user }))

          call_action(comment, { comment: new_attributes })

          comment.reload
          expect(comment.body.body.as_json).to eq('Testing comments controller.')
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

  describe 'DELETE /destroy' do
    def call_action(comment = create(:comment))
      delete comment_url(comment)
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before { sign_in user }

      it 'destroys the requested comment' do
        comment = create(:comment, valid_attributes)
        expect do
          call_action(comment)
        end.to change(Comment, :count).by(-1)
      end
    end

    it 'does not destroy another user\'s comment' do
      comment = create(:comment, valid_attributes({ user: another_user }))
      expect do
        call_action(comment)
      end.not_to change(Comment, :count)
    end
  end
end
