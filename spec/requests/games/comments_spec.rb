# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/games/comments', type: :request do
  it_behaves_like 'is_commentable' do
    let(:commentable) { create(:game) }
    let(:url) { game_comments_path(game_id: commentable.id) }
  end
end
