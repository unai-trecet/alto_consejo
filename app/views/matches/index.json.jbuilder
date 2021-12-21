# frozen_string_literal: true

json.array! @matches, partial: 'matches/match', as: :match
