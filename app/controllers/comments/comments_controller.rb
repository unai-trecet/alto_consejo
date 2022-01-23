# frozen_string_literal: true

module Comments
  class CommentsController < ApplicationController
    include Commentable

    before_action :set_commentable

    private

    def set_commentable
      @parent = Comment.find(params[:comment_id])
      @commentable = @parent.commentable # Can be a Match, Game, etc
    end
  end
end
