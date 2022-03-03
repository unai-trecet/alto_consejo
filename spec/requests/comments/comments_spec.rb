# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/comments', type: :request do
  it_behaves_like 'is_commentable' do
    let(:commentable) { create(:comment) }
    let(:url) { comment_comments_path(comment_id: commentable.id) }
  end
end
