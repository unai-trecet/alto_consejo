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
  has_many :matches
  alias_attribute :created_matches, :matches

  has_many :match_participants
  has_many :participations, through: :match_participants, source: :match
  has_many :played_matches, -> { played }, through: :match_participants, source: :match

  has_many :match_invitations
  has_many :invitations, through: :match_invitations, source: :match

  has_many :comments
end
