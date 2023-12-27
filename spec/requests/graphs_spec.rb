require 'rails_helper'

RSpec.describe GraphsController, type: :request do
  let(:user) { create(:user, :confirmed) }
  
  describe 'GET user_played_matches' do
    def call_action(from_date: 1.month.ago)
      get '/graphs/user_played_matches', params: { from_date: }
    end

    it_behaves_like 'not_logged_in'

    context 'user authenticated' do
      before { sign_in(user) }

      it 'returns a JSON response with the count of played matches grouped by day' do
        from_date = 1.month.ago

        # Assuming you have played matches associated with the current_user
        matches = 5.times.map do |n|
          match = create(:match, end_at: Time.now - n.days)
          create(:match_participant, user:, match:)
          match
        end

        call_action(from_date:)

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_response = JSON.parse(response.body)

        expect(json_response).to be_a(Hash)
        expect(json_response.keys).to all(be_a(String))
        expect(json_response.values).to all(be_an(Integer))

        # Check if the returned JSON contains the correct dates and counts
        matches.each do |match|
          date = match.end_at.to_date.to_s
          expect(json_response[date]).to eq(1)
        end
      end
    end
  end

  describe 'GET user_organized_matches' do

    def call_action(from_date: 1.month.ago)
      get '/graphs/user_organized_matches', params: { from_date: }
    end

    it_behaves_like 'not_logged_in'

    context 'user authenticated' do
      before { sign_in(user) }

      it 'returns a JSON response with the count of organized matches grouped by day' do
        from_date = 1.month.ago

        # Assuming you have matches associated with the current_user
        matches = 5.times.map do |n|
          create(:match, user:, created_at: Time.now - n.days)
        end

        call_action(from_date:)

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_response = JSON.parse(response.body)

        expect(json_response).to be_a(Hash)
        expect(json_response.keys).to all(be_a(String))
        expect(json_response.values).to all(be_an(Integer))

        # Check if the returned JSON contains the correct dates and counts
        matches.each do |match|
          date = match.created_at.to_date.to_s
          expect(json_response[date]).to eq(1)
        end
      end
    end
  end
end
