# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'notifications/show', type: :view do
  before(:each) do
    @notification = assign(:notification, create(:notification, :match_invitation_notification))
  end

  it 'renders attributes in <p>' do
    render
  end
end
