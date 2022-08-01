# frozen_string_literal: true

module Games
  class CommentsController < ApplicationController
    include Commentable

    before_action :set_commentable

    private

    def set_commentable
      @commentable = Game.find(params[:game_id])
    end
  end
end
