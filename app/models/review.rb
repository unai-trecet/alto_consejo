class Review < ApplicationRecord
  belongs_to :user
  belongs_to :game

  has_rich_text :content

  validates :user, :content, presence: true
  validates :user_id, uniqueness: { scope: :game_id, message: 'can only review a game once' }

  after_commit :broadcast_review
  def broadcast_review
    broadcast_replace_to [game, :reviews],
                         target: dom_id(game, :reviews),
                         partial: 'games/reviews',
                         locals: { game: }
  end
end
