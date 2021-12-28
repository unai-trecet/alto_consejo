# frozen_string_literal: true

class Match < ApplicationRecord
  belongs_to :user
  belongs_to :game

  alias_attribute :creator, :user

  validates :title, :start_at, :end_at, presence: true

  scope :played, -> { where('end_at < ?', DateTime.now) }
  scope :not_played, -> { where('end_at > ?', DateTime.now) }
end
