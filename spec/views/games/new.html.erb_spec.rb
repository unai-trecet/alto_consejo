require 'rails_helper'

RSpec.describe 'games/new', type: :view do
  before(:each) do
    assign(:game, Game.new(
                    name: 'MyString',
                    description: 'MyString',
                    author: '',
                    user: nil,
                    bbg_link: 'MyText',
                    image: 'MyText'
                  ))
  end

  it 'renders new game form' do
    render

    assert_select 'form[action=?][method=?]', games_path, 'post' do
      assert_select 'input[name=?]', 'game[name]'

      assert_select 'input[name=?]', 'game[description]'

      assert_select 'input[name=?]', 'game[author]'

      assert_select 'input[name=?]', 'game[user_id]'

      assert_select 'textarea[name=?]', 'game[bbg_link]'

      assert_select 'textarea[name=?]', 'game[image]'
    end
  end
end
