# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :user
  alias_attribute :added_by, :user

  has_many :matches

  validates :user_id, :name, presence: true
  validates :name, uniqueness: true

  def played_matches
    matches.played
  end

  def planned_matches
    matches.not_played
  end

  def players
    played_matches.includes(:participants).map(&:participants).flatten.uniq
  end
end
