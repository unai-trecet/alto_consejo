# frozen_string_literal: true

class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :author, :bbg_link, :image
  belongs_to :user
end
