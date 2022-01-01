# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'notifications/index', type: :view do
  let(:notifications) do
    Kaminari.paginate_array(create_list(:notification, 10, :match_invitation_notification)).page(1)
  end

  it 'renders a list of notifications' do
    assign(:notifications, notifications)
    render
  end
end
