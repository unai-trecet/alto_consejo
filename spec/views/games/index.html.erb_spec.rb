# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'games/index', type: :view do
  let(:games) do
    games = [
      create(:game,
             name: 'Name',
             description: 'Description',
             author: '',
             bbg_link: 'MyText',
             image: 'MyImage'),
      create(:game,
             name: 'Name 2',
             description: 'Description',
             author: '',
             bbg_link: 'MyText',
             image: 'MyImage')
    ]
    Kaminari.paginate_array(games).page(1)
  end

  it 'renders a list of games' do
    assign(:games, games)
    assign(:q, Game.ransack(nil))

    render

    assert_select 'tr>td', text: 'Name', count: 1
    assert_select 'tr>td', text: 'Name 2', count: 1
    assert_select 'tr>td', text: 'MyText', count: 2
    assert_select 'tr>td', text: 'MyText', count: 2
  end
end
