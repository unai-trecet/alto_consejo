require 'rails_helper'

RSpec.describe '/matches', type: :request do
  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Match.create! valid_attributes
      get matches_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      match = Match.create! valid_attributes
      get match_url(match)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_match_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      match = Match.create! valid_attributes
      get edit_match_url(match)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Match' do
        expect do
          post matches_url, params: { match: valid_attributes }
        end.to change(Match, :count).by(1)
      end

      it 'redirects to the created match' do
        post matches_url, params: { match: valid_attributes }
        expect(response).to redirect_to(match_url(Match.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Match' do
        expect do
          post matches_url, params: { match: invalid_attributes }
        end.to change(Match, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post matches_url, params: { match: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested match' do
        match = Match.create! valid_attributes
        patch match_url(match), params: { match: new_attributes }
        match.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the match' do
        match = Match.create! valid_attributes
        patch match_url(match), params: { match: new_attributes }
        match.reload
        expect(response).to redirect_to(match_url(match))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        match = Match.create! valid_attributes
        patch match_url(match), params: { match: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested match' do
      match = Match.create! valid_attributes
      expect do
        delete match_url(match)
      end.to change(Match, :count).by(-1)
    end

    it 'redirects to the matches list' do
      match = Match.create! valid_attributes
      delete match_url(match)
      expect(response).to redirect_to(matches_url)
    end
  end
end
