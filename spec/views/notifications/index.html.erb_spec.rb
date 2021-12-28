require 'rails_helper'

RSpec.describe "notifications/index", type: :view do
  before(:each) do
    assign(:notifications, [
      create(:notification, :match_invitation_notification),
      create(:notification, :match_invitation_notification)
    ])
  end

  it "renders a list of notifications" do
    render
  end
end
