# frozen_string_literal: true

class Game < ApplicationRecord
  has_rich_text :description

  belongs_to :user
  alias_attribute :added_by, :user

  has_many :matches
  has_many :played_matches, -> { played }, class_name: 'Match'
  has_many :planned_matches, -> { not_played }, class_name: 'Match'

  has_many :comments, as: :commentable

  has_one_attached :main_image
  has_many_attached :game_pictures
  has_rich_text :description

  validates :user_id, :name, presence: true
  validates :name, uniqueness: true

  def players
    played_matches.includes(:participants).map(&:participants).flatten.uniq
  end

  ransacker :matches_count do
    query = '(SELECT COUNT(matches.game_id) FROM matches WHERE matches.game_id = games.id GROUP BY matches.game_id)'
    Arel.sql(query)
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user matches]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[added_by admin_id author bbg_link created_at description id id_value image
       matches_count name updated_at user_id]
  end

  def creator_name
    creator.added_by
  end

  def image_as_thumbnail
    main_image.variant(resize_to_limit: [300, 300]).processed
  end

  def pictures_as_thumbnails
    game_pictures.map do |picture|
      picture.variant(resize_to_limit: [150, 150]).processed
    end
  end

  def image_as_card_img
    main_image.variant(resize_to_limit: [150, 150]).processed
  end
end
