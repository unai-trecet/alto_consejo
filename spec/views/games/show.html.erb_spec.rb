require 'rails_helper'

RSpec.describe 'games/show', type: :view do
  before(:each) do
    @game = assign(:game, Game.create!(
                            name: 'Name',
                            description: 'Description',
                            author: '',
                            user: build(:user),
                            bbg_link: 'MyText',
                            image: 'MyImage'
                          ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
