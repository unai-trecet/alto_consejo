# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  scope :accepted, -> { where('accepted_at IS NOT NULL') }
  scope :pending, -> { where('accepted_at IS NULL') }

  validates :user, :friend, presence: true
end
