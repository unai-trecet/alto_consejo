# frozen_string_literal: true

class MatchParticipant < ApplicationRecord
  belongs_to :user
  belongs_to :match

  validates :user_id, :match_id, presence: true
  validates :user_id, uniqueness: { scope: :match_id }

  def match_creator
    match.user
  end
end
