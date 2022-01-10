# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalendarsController, type: :request do
  let(:user) { create(:user, :confirmed) }
  describe 'GET /matches_calendar' do
    def call_action
      get '/matches_calendar'
    end

    it_behaves_like 'not_logged_in'

    it 'renders a successful response calling expeccted MAtch scope.' do
      sign_in(user)
      expect(Match).to receive(:related_to_user).with(user.id).and_call_original

      call_action

      expect(response).to be_successful
      expect(response).to render_template('matches_calendar')
    end
  end
end
