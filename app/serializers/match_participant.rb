# frozen_string_literal: true

class MatchPArticipant < ActiveModel::Serializer
  belongs_to :user
  belongs_to :match
end
