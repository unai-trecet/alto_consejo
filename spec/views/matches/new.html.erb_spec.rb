require 'rails_helper'

RSpec.describe "matches/new", type: :view do
  before(:each) do
    assign(:match, Match.new(
      title: "MyText",
      description: "MyText",
      user: nil,
      game: nil,
      location: "MyText",
      number_of_players: 1
    ))
  end

  it "renders new match form" do
    render

    assert_select "form[action=?][method=?]", matches_path, "post" do

      assert_select "textarea[name=?]", "match[title]"

      assert_select "textarea[name=?]", "match[description]"

      assert_select "input[name=?]", "match[user_id]"

      assert_select "input[name=?]", "match[game_id]"

      assert_select "textarea[name=?]", "match[location]"

      assert_select "input[name=?]", "match[number_of_players]"
    end
  end
end
