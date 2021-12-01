require 'rails_helper'

RSpec.describe "MatchParticipants", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/match_participants/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/match_participants/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
