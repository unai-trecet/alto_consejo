class Review < ApplicationRecord
  acts_as_votable

  belongs_to :user
  belongs_to :game

  has_rich_text :content

  validates :user, :content, presence: true
  validates :user_id, uniqueness: { scope: :game_id, message: 'can only review a game once' }

  after_create_commit :broadcast_review_created
  after_update_commit :broadcast_likes, if: -> { saved_change_to_cached_votes_up? }
  after_destroy_commit do
    broadcast_remove_to dom_id(self)
  end

  private

  def broadcast_review_created
    broadcast_replace_to [game, :reviews],
                         target: dom_id(game, :reviews),
                         partial: 'games/reviews',
                         locals: { game:, user: nil }
  end

  def broadcast_likes
    broadcast_replace_later_to [self, :votes],
                               target: dom_id(self, :votes),
                               partial: 'shared/likes_counter',
                               locals: { likeable: self }
  end
end
