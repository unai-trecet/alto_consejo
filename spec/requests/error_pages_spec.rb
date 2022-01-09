# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ErrorPagesController, type: :request do
  describe 'GET /403' do
    it 'renders a successful response' do
      get unauthorized_url

      expect(response).to be_successful
      expect(response).to render_template('403')
    end
  end
end
