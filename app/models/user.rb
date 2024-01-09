# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  validates :email, :username, presence: true, uniqueness: true
  validates :role, inclusion: { in: %w[user admin] }

  acts_as_voter

  has_many :notifications, as: :recipient

  has_many :games

  # MATCHES ASSOCIATIONS
  has_many :matches
  alias created_matches matches

  has_many :match_participants
  has_many :participations, through: :match_participants, source: :match

  has_many :played_matches, -> { played }, through: :match_participants, source: :match
  has_many :not_played_matches, -> { not_played }, through: :match_participants, source: :match

  has_many :played_games, -> { distinct }, through: :played_matches, source: :game

  has_many :match_invitations
  has_many :invitations, through: :match_invitations, source: :match

  # FRIENDSHIPS
  has_many :friendships, ->(user) { unscope(:where).where('user_id = ? OR friend_id = ?', user.id, user.id) }
  has_many :accepted_friendships, lambda { |user|
                                    unscope(:where).accepted.where('user_id = ? OR friend_id = ?', user.id, user.id)
                                  }, class_name: 'Friendship'
  has_many :pending_friendships, lambda { |user|
                                   unscope(:where).pending.where('user_id = ? OR friend_id = ?', user.id, user.id)
                                 }, class_name: 'Friendship'
  has_many :friends, through: :accepted_friendships, source: :user


  after_commit :add_default_avatar, on: %i[create update]

  # COMMENTS
  has_many :authored_comments, class_name: 'Comment'
  has_many :comments, as: :commentable

  has_one_attached :avatar

  # RATINGS & REVIEWS
  has_many :ratings
  has_many :reviews

  def admin?
    role == 'admin'
  end

  def avatar_as_thumbnail
    avatar.variant(resize_to_limit: [150, 150]).processed
  end

  def friends
    accepted_friendships.includes(:user, :friend).map { |fr| [fr.user, fr.friend] - [self] }.flatten
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[confirmation_sent_at confirmation_token confirmed_at created_at created_matches
       current_sign_in_at current_sign_in_ip email encrypted_password id id_value last_sign_in_at last_sign_in_ip
       remember_created_at reset_password_sent_at reset_password_token sign_in_count unconfirmed_email updated_at
       username]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[games]
  end

  def already_rated?(rateable)
    ratings.where(rateable:).exists?
  end

  def rating_for(rateable)
    ratings.find_by(rateable:)
  end

  private

  def add_default_avatar
    return if avatar.attached?

    avatar.attach(
      io: File.open(Rails.root.join('app', 'assets', 'images', 'default_avatar.png')),
      filename: 'default_avatar.png',
      content_type: 'image/png'
    )
  end
end
