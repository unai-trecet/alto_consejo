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

  has_one_attached :image
  has_many_attached :pictures
  has_rich_text :description

  validates :title, :start_at, :end_at, presence: true

  scope :played, -> { where('end_at < ?', DateTime.now) }
  scope :not_played, -> { where('end_at > ?', DateTime.now) }
  scope :open, -> { where(public: true) }

  filter_scope :all_by_user, lambda { |user_id|
    left_joins(:match_participants, :match_invitations)
      .where(user_id:)
      .or(where(public: true))
      .or(where(match_participants: { user_id: }))
      .or(where(match_invitations: { user_id: }))
      .distinct
  }
  filter_scope :participations_by_user, lambda { |user_id|
    joins(:match_participants)
      .where(match_participants: { user_id: })
  }
  filter_scope :played_by_user, lambda { |user_id|
    played
      .joins(:match_participants)
      .where(match_participants: { user_id: })
  }
  filter_scope :not_played_by_user, lambda { |user_id|
    not_played
      .joins(:match_participants)
      .where(match_participants: { user_id: })
  }
  filter_scope :invitations_by_user, lambda { |user_id|
    joins(:match_invitations)
      .where(match_invitations: { user_id: })
  }
  filter_scope :created_by_user, ->(user_id) { where(user_id:) }
  filter_scope :related_to_user, lambda { |user_id|
    left_joins(:match_participants, :match_invitations)
      .where(user_id:)
      .or(where(match_participants: { user_id: }))
      .or(where(match_invitations: { user_id: }))
      .distinct
  }

  # TODO: Add tests for the following methods
  def game_name
    game.name
  end

  def creator_name
    creator.username
  end

  def image_as_thumbnail
    image.variant(resize_to_limit: [300, 300]).processed
  end

  def pictures_as_thumbnails
    pictures.map do |picture|
      picture.variant(resize_to_limit: [150, 150]).processed
    end
  end

  def image_as_card_img
    image.variant(resize_to_limit: [150, 150]).processed
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at creator description end_at game_id id id_value invited_users location number_of_players public
       start_at title updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user game]
  end
end
