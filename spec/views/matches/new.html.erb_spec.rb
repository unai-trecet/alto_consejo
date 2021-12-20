require 'rails_helper'

RSpec.describe 'matches/new', type: :view do
  let(:user) { create(:user, :confirmed) }

  before(:each) do
    sign_in user
    assign(:match, Match.new)
  end

  it 'renders new match form' do
    render

    assert_select 'form[action=?][method=?]', matches_path, 'post' do
      assert_select 'textarea[name=?]', 'match[title]'

      assert_select 'textarea[name=?]', 'match[description]'

      assert_select 'input[name=?]', 'match[user_id]'

      assert_select 'select[name=?]', 'match[game_id]'

      assert_select 'textarea[name=?]', 'match[location]'

      assert_select 'input[name=?]', 'match[number_of_players]'
    end
  end
end
