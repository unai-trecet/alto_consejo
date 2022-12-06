# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  validates :email, :username, presence: true, uniqueness: true

  has_many :notifications, as: :recipient

  has_many :games

  # MATCHES ASSOCIATIONS
  has_many :matches
  alias_attribute :created_matches, :matches

  has_many :match_participants
  has_many :participations, through: :match_participants, source: :match

  has_many :played_matches, -> { played }, through: :match_participants, source: :match
  has_many :not_played_matches, -> { not_played }, through: :match_participants, source: :match

  has_many :played_games, -> { distinct }, through: :played_matches, source: :game

  has_many :match_invitations
  has_many :invitations, through: :match_invitations, source: :match

  # FRIENDSHIPS
  has_many :friendships, ->(user) { unscope(:where).where('user_id = ? OR friend_id = ?', user.id, user.id) }
  has_many :accepted_friendships, -> { accepted }, class_name: 'Friendship', foreign_key: :friend_id
  has_many :pending_friendships, -> { pending }, class_name: 'Friendship', foreign_key: :friend_id

  after_commit :add_default_avatar, on: %i[create update]

  has_many :comments
  has_one_attached :avatar

  def avatar_as_thumbnail
    avatar.variant(resize_to_limit: [150, 150]).processed
  end

  def friends
    friendships.accepted.includes(:user, :friend).map { |fr| [fr.user, fr.friend] - [self] }.flatten
  end

  private

  # TODO: Add test for add_default_avatar
  def add_default_avatar
    return if avatar.attached?

    avatar.attach(
      io: File.open(Rails.root.join('app', 'assets', 'images', 'default_avatar.png')),
      filename: 'default_avatar.png',
      content_type: 'image/png'
    )
  end
end
