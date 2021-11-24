require 'rails_helper'

RSpec.describe "matches/edit", type: :view do
  before(:each) do
    @match = assign(:match, Match.create!(
      title: "MyText",
      description: "MyText",
      user: nil,
      game: nil,
      location: "MyText",
      number_of_players: 1
    ))
  end

  it "renders the edit match form" do
    render

    assert_select "form[action=?][method=?]", match_path(@match), "post" do

      assert_select "textarea[name=?]", "match[title]"

      assert_select "textarea[name=?]", "match[description]"

      assert_select "input[name=?]", "match[user_id]"

      assert_select "input[name=?]", "match[game_id]"

      assert_select "textarea[name=?]", "match[location]"

      assert_select "input[name=?]", "match[number_of_players]"
    end
  end
end
