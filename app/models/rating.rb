class Rating < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user
  belongs_to :rateable, polymorphic: true

  validates :value, presence: true, inclusion: { in: 0..10 }
  validates :user_id, uniqueness: { scope: %i[rateable_type rateable_id], message: 'can rate only once per item' }

  after_commit :broadcast_rating
  def broadcast_rating
    broadcast_replace_to [rateable, :average_rating],
                         target: dom_id(rateable, :average_rating),
                         partial: 'ratings/average_rating_stars',
                         locals: { rateable: rateable }
  end
end
