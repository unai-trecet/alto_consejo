# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'matches/edit', type: :view do
  let(:user) { create(:user, :confirmed) }

  before(:each) do
    sign_in user
    @match = assign(:match, create(:match,
                                   title: 'MyText',
                                   description: 'MyText',
                                   location: 'MyText',
                                   number_of_players: 1))
  end

  it 'renders the edit match form' do
    render

    assert_select 'form[action=?][method=?]', match_path(@match), 'post' do
      assert_select 'textarea[name=?]', 'match[title]'

      assert_select 'textarea[name=?]', 'match[description]'

      assert_select 'input[name=?]', 'match[user_id]'

      assert_select 'select[name=?]', 'match[game_id]'

      assert_select 'textarea[name=?]', 'match[location]'

      assert_select 'input[name=?]', 'match[number_of_players]'
    end
  end
end
