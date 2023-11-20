# frozen_string_literal: true

module Users
  class CommentsController < ApplicationController
    include Commentable

    before_action :set_commentable

    private

    def set_commentable
      @commentable = User.find(params[:user_id])
    end
  end
end
