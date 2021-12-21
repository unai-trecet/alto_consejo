# frozen_string_literal: true

class MatchParticipant < ApplicationRecord
  belongs_to :user
  belongs_to :match

  def match_creator
    match.user
  end
end
