# frozen_string_literal: true

class Match < ApplicationRecord
  include Filterable

  belongs_to :user
  alias_attribute :creator, :user
  belongs_to :game
  
  has_many :match_participants
  has_many :participants, through: :match_participants, source: :user

  has_many :match_invitations
  has_many :invitees, through: :match_invitations, source: :user

  has_many :comments, as: :commentable

  validates :title, :start_at, :end_at, presence: true

  scope :played, -> { where('end_at < ?', DateTime.now) }
  scope :not_played, -> { where('end_at > ?', DateTime.now) }
  scope :open, -> { where(public: true) }

  filter_scope :all_by_user, lambda { |user_id|
    left_joins(:match_participants, :match_invitations)
      .where(user_id: user_id)
      .or(where(public: true))
      .or(where(match_participants: { user_id: user_id }))
      .or(where(match_invitations: { user_id: user_id }))
      .distinct
  }
  filter_scope :participations_by_user, lambda { |user_id|
    joins(:match_participants)
      .where(match_participants: { user_id: user_id })
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
  filter_scope :related_to_user, lambda { |user_id|
    left_joins(:match_participants, :match_invitations)
      .where(user_id: user_id)
      .or(where(match_participants: { user_id: user_id }))
      .or(where(match_invitations: { user_id: user_id }))
      .distinct
  }
end
