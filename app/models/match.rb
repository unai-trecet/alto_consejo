# frozen_string_literal: true

class Match < ApplicationRecord
  belongs_to :user
  belongs_to :game

  has_many :match_participants
  has_many :participants, through: :match_participants, source: :user

  has_many :match_invitations
  has_many :invitees, through: :match_invitations, source: :user

  alias_attribute :creator, :user

  validates :title, :start_at, :end_at, presence: true

  scope :played, -> { where('end_at < ?', DateTime.now) }
  scope :not_played, -> { where('end_at > ?', DateTime.now) }
end
