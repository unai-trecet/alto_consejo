# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutocompleteGameName do
  let(:game_name) { 'Gloomhaven' }
  subject(:bgg_name_suggestions) { described_class.new(game_name) }

  describe '#call' do
    let(:bgg_url) { 'https://www.boardgamegeek.com' }
    let(:bgg_path) { '/xmlapi/search' }
    let(:bgg_query) { { query: { search: game_name } } }
    let(:bgg_response_parsed_body) do
      { 'boardgames' =>
         { 'boardgame' =>
           [{ 'name' => { '__content__' => 'Gloomhaven: Jaws of the Lion', 'primary' => 'true' }, 'yearpublished' => '2020', 'objectid' => '291457' },
            { 'name' => { '__content__' => 'Gloomhaven: Jaws of the Lion – Roguish Individuals', 'primary' => 'true' },
              'yearpublished' => '2021', 'objectid' => '354666' }],
           'termsofuse' => 'https://boardgamegeek.com/xmlapi/termsofuse' } }
    end
    let(:bgg_response) { instance_double(HTTParty::Response, parsed_response: bgg_response_parsed_body) }

    before do
      allow(described_class).to receive(:get).and_return(bgg_response)
    end

    it 'hits BGG api' do
      bgg_name_suggestions.call

      expect(described_class.base_uri).to eq(bgg_url)
      expect(described_class).to have_received(:get).with(bgg_path, bgg_query)
    end

    it 'returns correct parsed game names' do
      expect(bgg_name_suggestions.call).to match_array(['Gloomhaven: Jaws of the Lion',
                                                        'Gloomhaven: Jaws of the Lion – Roguish Individuals'])
    end
  end
end
