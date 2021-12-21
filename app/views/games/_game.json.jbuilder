# frozen_string_literal: true

json.extract! game, :id, :name, :description, :author, :user_id, :bbg_link, :image, :created_at, :updated_at
json.url game_url(game, format: :json)
