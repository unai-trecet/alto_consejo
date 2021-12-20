require 'rails_helper'

RSpec.describe 'matches/show', type: :view do
  before(:each) do
    @match = assign(:match, create(:match,
                                   title: 'MyText',
                                   description: 'MyText',
                                   location: 'MyText',
                                   number_of_players: 2))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2/)
  end
end
