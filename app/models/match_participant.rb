# frozen_string_literal: true

class MatchParticipant < ApplicationRecord
  belongs_to :user
  belongs_to :match

  validates :user_id, :match_id, presence: true
  validates :user_id,
            uniqueness: { scope: :match_id,
                          message: I18n.t('.activerecord.errors.models.match_participant.user.unique_user_and_match') }
  def match_creator
    match.user
  end
end
