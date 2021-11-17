require 'rails_helper'

RSpec.describe '/games', type: :request do
  # Game. As you add validations to Game, be sure to
  # adjust the attributes here as well.
  let(:user) { create(:user, :confirmed) }
  let(:valid_attributes) do
    {
      name: 'LOTR',
      description: 'Card game',
      author: 'Tolkien',
      user_id: user.id,
      admin_id: nil,
      bbg_link: 'MyText',
      image: 'MyImage',
      created_at: 'Wed, 17 Nov 2021 11:32:30.977859000 UTC +00:00',
      updated_at: 'Wed, 17 Nov 2021 11:32:30.977859000 UTC +00:00'
    }
  end

  let(:invalid_attributes) do
    {
      name: 'LOTR',
      description: 'Card game',
      author: 'Tolkien',
      user_id: nil,
      admin_id: nil,
      bbg_link: 'MyText',
      image: 'MyImage',
      created_at: 'Wed, 17 Nov 2021 11:32:30.977859000 UTC +00:00',
      updated_at: 'Wed, 17 Nov 2021 11:32:30.977859000 UTC +00:00'
    }
  end

  before { sign_in user }

  describe 'GET /index' do
    it 'renders a successful response' do
      Game.create! valid_attributes
      get games_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      game = Game.create! valid_attributes
      get game_url(game)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_game_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      game = Game.create! valid_attributes
      get edit_game_url(game)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Game' do
        expect do
          post games_url, params: { game: valid_attributes }
        end.to change(Game, :count).by(1)
      end

      it 'redirects to the created game' do
        post games_url, params: { game: valid_attributes }
        expect(response).to redirect_to(game_url(Game.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Game' do
        expect do
          post games_url, params: { game: invalid_attributes }
        end.to change(Game, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post games_url, params: { game: invalid_attributes }
        expect(response.status).to eq(422)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'LOTR 2' }
      end

      it 'updates the requested game' do
        game = Game.create! valid_attributes
        patch game_url(game), params: { game: new_attributes }
        game.reload
        expect(game.name).to eq('LOTR 2')
      end

      it 'redirects to the game' do
        game = Game.create! valid_attributes
        patch game_url(game), params: { game: new_attributes }
        game.reload
        expect(response).to redirect_to(game_url(game))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        game = Game.create! valid_attributes
        patch game_url(game), params: { game: invalid_attributes }
        expect(response.status).to eq(422)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested game' do
      game = Game.create! valid_attributes
      expect do
        delete game_url(game)
      end.to change(Game, :count).by(-1)
    end

    it 'redirects to the games list' do
      game = Game.create! valid_attributes
      delete game_url(game)
      expect(response).to redirect_to(games_url)
    end
  end
end
