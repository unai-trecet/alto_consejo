# frozen_string_literal: true

class Comment < ApplicationRecord
  include ActionView::RecordIdentifier
  acts_as_votable

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :parent, optional: true, class_name: 'Comment'

  has_many :comments, foreign_key: :parent_id, dependent: :destroy

  has_rich_text :body

  validates :body, :user, presence: true

  after_create_commit do
    broadcast_append_later_to [commentable, :comments],
                              target: "#{dom_id(parent || commentable)}_comments",
                              partial: 'comments/comment_with_replies'
  end

  after_update_commit :broadcast_comment_update, if: :body_changed?

  def body_changed?
    body.previous_changes.key?('body')
  end

  def broadcast_comment_update
    broadcast_replace_to self,
                         target: dom_id(self),
                         partial: 'comments/comment'
  end

  after_destroy_commit do
    broadcast_remove_to self
    broadcast_action_to self, action: :remove, target: "#{dom_id(self)}_with_comments"
  end

  after_update_commit :broadcast_votes, if: -> { saved_change_to_cached_votes_up? }

  private

  def broadcast_votes
    broadcast_replace_later_to [self, :votes],
                               target: dom_id(self, :votes),
                               partial: 'shared/likes_counter',
                               locals: { comment: self }
  end
end
