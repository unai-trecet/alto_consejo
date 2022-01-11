# frozen_string_literal: true

module Matches
  class CommentsController < ApplicationController
    include Commentable

    before_action :set_commentable

    private

    def set_commentable
      @commentable = Match.find(params[:match_id])
    end
  end
end
