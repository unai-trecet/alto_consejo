class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :rateable, polymorphic: true

  validates :value, presence: true, inclusion: { in: 0..5 }
  validates :user_id, uniqueness: { scope: %i[rateable_type rateable_id], message: 'can rate only once per item' }
end
