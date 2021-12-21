# frozen_string_literal: true

class MatchSerializer < ActiveModel::Serializer
  attributes :id, :tite, :description, :location, :start_at, :end_at, :number_of_players

  belongs_to :game
  belongs_to :user
end
