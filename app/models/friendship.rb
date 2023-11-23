# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  scope :accepted, -> { where('accepted_at IS NOT NULL') }
  scope :pending, -> { where('accepted_at IS NULL') }

  validates :user, :friend, presence: true

  def self.already_exists?(user_id:, friend_id:)
    exists?([
              '(user_id = :a AND friend_id = :b) OR (user_id = :b AND friend_id = :a)',
              { a: user_id, b: friend_id }
            ])
  end
end
