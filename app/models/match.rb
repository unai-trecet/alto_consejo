# frozen_string_literal: true

class Match < ApplicationRecord
  include Filterable

  belongs_to :user
  belongs_to :game

  has_many :match_participants
  has_many :participants, through: :match_participants, source: :user

  has_many :match_invitations
  has_many :invitees, through: :match_invitations, source: :user

  alias_attribute :creator, :user

  validates :title, :start_at, :end_at, presence: true

  filter_scope :played, -> { where('end_at < ?', DateTime.now) }
  filter_scope :not_played, -> { where('end_at > ?', DateTime.now) }
  filter_scope :open, -> { where(public: true) }
  filter_scope :all_by_user, lambda { |user_id|
    left_joins(:match_participants, :match_invitations)
      .where(user_id: user_id)
      .or(where(public: true))
      .or(where(match_participants: { user_id: user_id }))
      .or(where(match_invitations: { user_id: user_id }))
  }
  filter_scope :played_by_user, lambda { |user_id|
    played
      .joins(:match_participants)
      .where(match_participants: { user_id: user_id })
  }
  filter_scope :not_played_by_user, lambda { |user_id|
    not_played
      .joins(:match_participants)
      .where(match_participants: { user_id: user_id })
  }
  filter_scope :invitations_by_user, lambda { |user_id|
    joins(:match_invitations)
      .where(match_invitations: { user_id: user_id })
  }
  filter_scope :created_by_user, ->(user_id) { where(user_id: user_id) }
end
