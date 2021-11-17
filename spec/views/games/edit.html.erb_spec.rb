require 'rails_helper'

RSpec.describe 'games/edit', type: :view do
  before(:each) do
    @game = assign(:game, Game.create!(
                            name: 'MyString',
                            description: 'MyString',
                            author: '',
                            user: build(:user),
                            bbg_link: 'MyText',
                            image: 'MyImage'
                          ))
  end

  it 'renders the edit game form' do
    render

    assert_select 'form[action=?][method=?]', game_path(@game), 'post' do
      assert_select 'input[name=?]', 'game[name]'

      assert_select 'input[name=?]', 'game[description]'

      assert_select 'input[name=?]', 'game[author]'

      assert_select 'textarea[name=?]', 'game[bbg_link]'

      assert_select 'textarea[name=?]', 'game[image]'
    end
  end
end
