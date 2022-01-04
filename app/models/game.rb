# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :user
  alias_attribute :added_by, :user

  has_many :matches
  has_many :played_matches, -> { played }, class_name: 'Match'
  has_many :planned_matches, -> { not_played }, class_name: 'Match'

  validates :user_id, :name, presence: true
  validates :name, uniqueness: true

  def players
    played_matches.includes(:participants).map(&:participants).flatten.uniq
  end
end
