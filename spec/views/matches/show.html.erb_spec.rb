# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'matches/show', type: :view do
  let(:creator) { create(:user, :confirmed, username: 'supercreator') }
  let!(:pera) { create(:user, :confirmed, username: 'pera') }

  before(:each) do
    sign_in(creator)
    @match = assign(:match, create(:match,
                                   title: 'Amazing game',
                                   description: 'Dungeon crawler',
                                   location: 'At my place',
                                   number_of_players: 2,
                                   invited_users: %w[supercreator pera],
                                   start_at: '2021-11-24 18:09:43',
                                   end_at: '2021-11-24 20:09:43',
                                   creator:,
                                   game: create(:game, name: 'Gloomhaven')))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Amazing game/)
    expect(rendered).to match(/Dungeon crawler/)
    expect(rendered).to match(/At my place/)
    expect(rendered).to match(/pera/)
    expect(rendered).to match(/supercreator/)
    expect(rendered).to match(/24 de noviembre de 2021 a las 18:09/)
    expect(rendered).to match(/24 de noviembre de 2021 a las 20:09/)
    expect(rendered).to match(/supercreator/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Cambiar partida/)
    expect(rendered).to match(/Todas las partidas/)
  end

  it 'renders joining button if current_user is invited and has not yet joined' do
    render
    expect(rendered).to match(/Unirme a partida/)
  end

  it 'does not render joining button if current_user is not invited' do
    @match.invited_users = ['pollo']
    render
    expect(rendered).not_to match(/Unirme a partida/)
  end

  it 'does not render joining button if current_user is already joined' do
    create(:match_participant, user: creator, match: @match)
    render
    expect(rendered).not_to match(/Unirme a partida/)
  end
end
