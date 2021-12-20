require 'rails_helper'

RSpec.describe 'matches/index', type: :view do
  before(:each) do
    assign(:matches, [
             create(:match,
                    title: 'Gloomhaven game',
                    description: 'Amazing dungeon crawler',
                    location: 'MyText',
                    number_of_players: 9),
             create(:match,
                    title: 'Terraforming Mars game',
                    description: 'Terraform next humanity planet',
                    location: 'MyText',
                    number_of_players: 10)
           ])
  end

  it 'renders a list of matches' do
    render

    assert_select 'tr>td', text: 'Gloomhaven game', count: 1
    assert_select 'tr>td', text: 'Terraforming Mars game', count: 1
    assert_select 'tr>td', text: 'Amazing dungeon crawler', count: 1
    assert_select 'tr>td', text: 'Terraform next humanity planet', count: 1
    assert_select 'tr>td', text: 'MyText', count: 2
    assert_select 'tr>td', text: '9', count: 1
    assert_select 'tr>td', text: '10', count: 1
  end
end
