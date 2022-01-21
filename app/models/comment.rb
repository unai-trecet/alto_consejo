# frozen_string_literal: true

class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable

  has_rich_text :body

  validates :body, presence: true

  after_create_commit lambda {
    broadcast_append_later_to [commentable, :comments], target: "#{dom_id(commentable)}_comments"
  }
end
