# frozen_string_literal: true

class CommentsController < ApplicationController
  include Commentable

  before_action :set_commentable

  private

  def set_commentable
    @commentable = Comment.find(params[:comment_id])
  end
end
