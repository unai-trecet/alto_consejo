# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :user

  validates :user_id, :name, presence: true
  validates :name, uniqueness: true
end
