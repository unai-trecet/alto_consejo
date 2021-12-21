# frozen_string_literal: true

json.extract! match, :id, :title, :description, :user_id, :game_id, :location, :number_of_players, :start_at, :end_at,
              :created_at, :updated_at
json.url match_url(match, format: :json)
