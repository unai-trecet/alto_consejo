require 'rails_helper'

RSpec.describe "matches/index", type: :view do
  before(:each) do
    assign(:matches, [
      Match.create!(
        title: "MyText",
        description: "MyText",
        user: nil,
        game: nil,
        location: "MyText",
        number_of_players: 2
      ),
      Match.create!(
        title: "MyText",
        description: "MyText",
        user: nil,
        game: nil,
        location: "MyText",
        number_of_players: 2
      )
    ])
  end

  it "renders a list of matches" do
    render
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
  end
end
