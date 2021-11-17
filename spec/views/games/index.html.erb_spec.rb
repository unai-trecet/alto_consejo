require 'rails_helper'

RSpec.describe 'games/index', type: :view do
  before(:each) do
    assign(:games, [
             Game.create!(
               name: 'Name',
               description: 'Description',
               author: '',
               user: build(:user),
               bbg_link: 'MyText',
               image: 'MyImage'
             ),
             Game.create!(
               name: 'Name',
               description: 'Description',
               author: '',
               user: build(:user),
               bbg_link: 'MyText',
               image: 'MyImage'
             )
           ])
  end

  it 'renders a list of games' do
    render
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
    assert_select 'tr>td', text: 'Description'.to_s, count: 2
    assert_select 'tr>td', text: ''.to_s, count: 2
    assert_select 'tr>td', text: nil.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
  end
end
