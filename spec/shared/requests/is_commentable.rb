# frozen_string_literal: true

RSpec.shared_examples 'is_commentable' do
  let(:user) { create(:user, :confirmed) }

  def valid_params(input = {})
    { comment: { body: 'Testing comments.' }.merge(input) }
  end

  describe 'create' do
    def call_action(params: valid_params)
      post url, params:
    end

    it_behaves_like 'not_logged_in'

    it 'creates a valid comment belonging commentable' do
      sign_in(user)
      call_action

      commentable.reload
      expect(commentable.comments.count).to eq(1)
      expect(commentable.comments.last.body.body.as_json).to eq('Testing comments.')
    end

    it 'does not create a comment if invalid input' do
      sign_in(user)

      call_action(params: valid_params({ body: '' }))

      commentable.reload
      expect(commentable.comments.count).to eq(0)
    end
  end
end
