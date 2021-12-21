# frozen_string_literal: true

class Match < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :title, :start_at, :end_at, presence: true
end
