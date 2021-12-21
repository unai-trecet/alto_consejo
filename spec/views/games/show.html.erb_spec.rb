# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'games/show', type: :view do
  let(:user) { create(:user, :confirmed) }

  before(:each) do
    sign_in user
    @game = assign(:game, create(:game,
                                 name: 'Name',
                                 description: 'Description',
                                 author: '',
                                 bbg_link: 'MyText',
                                 image: 'MyImage'))
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
