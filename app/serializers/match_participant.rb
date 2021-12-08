class MatchPArticipant < ActiveModel::Serializer
  belongs_to :user
  belongs_to :match
end
