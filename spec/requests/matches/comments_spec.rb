# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/matches/comments', type: :request do
  it_behaves_like 'is_commentable' do
    let(:commentable) { create(:match) }
    let(:url) { match_comments_path(match_id: commentable.id) }
  end
end
