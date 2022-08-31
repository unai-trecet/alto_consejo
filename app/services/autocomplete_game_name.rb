# frozen_string_literal: true

class AutocompleteGameName
  include HTTParty
  base_uri 'https://www.boardgamegeek.com'

  def initialize(term)
    @term = term
  end

  def call
    suggestions
  end

  private

  def suggestions
    # TODO: move this into a constant variable frozen string.
    path = '/xmlapi/search'
    response = self.class.get(path, query: { search: @term })
    res = parse_names(response.parsed_response)
    res ? res.compact.take(10) : []
  end

  def parse_names(games_info)
    games_info['boardgames']['boardgame']&.map { |game| game['name']['__content__'] }
  end
end
