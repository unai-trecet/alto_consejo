# frozen_string_literal: true

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

  describe 'GET /index' do
    def call_action
      get games_url
    end

    it_behaves_like 'not_logged_in'

    it 'renders a successful response' do
      sign_in user
      create(:game, valid_attributes)

      call_action

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    def call_action(game = create(:game))
      get game_url(game)
    end

    it_behaves_like 'not_logged_in'

    it 'renders a successful response' do
      sign_in user
      game = create(:game, valid_attributes)

      call_action(game)

      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    def call_action
      get new_game_url
    end

    it_behaves_like 'not_logged_in'

    it 'renders a successful response' do
      sign_in user

      call_action

      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    def call_action(game = create(:game))
      get edit_game_url(game)
    end

    it_behaves_like 'not_logged_in'

    it 'renders a successful response' do
      sign_in user
      game = create(:game, valid_attributes)

      call_action(game)

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    def call_action(params = { game: valid_attributes })
      post games_url, params:
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before { sign_in user }
      context 'with valid parameters' do
        it 'creates a new Game' do
          expect do
            call_action
          end.to change(Game, :count).by(1)
        end

        it 'redirects to the created game' do
          call_action
          expect(response).to redirect_to(game_url(Game.last))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Game' do
          expect do
            call_action({ game: invalid_attributes })
          end.to change(Game, :count).by(0)
        end

        it "renders a successful response (i.e. to display the 'new' template)" do
          call_action({ game: invalid_attributes })

          expect(response.status).to eq(422)
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'PATCH /update' do
    def call_action(game = create(:game), params = { game: valid_attributes })
      patch game_url(game), params:
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before { sign_in user }
      context 'with valid parameters' do
        let(:new_attributes) do
          { name: 'LOTR 2' }
        end

        it 'updates the requested game' do
          game = create(:game, valid_attributes)

          call_action(game, { game: new_attributes })

          game.reload
          expect(game.name).to eq('LOTR 2')
        end

        it 'redirects to the game' do
          game = create(:game, valid_attributes)

          call_action(game, { game: new_attributes })

          game.reload
          expect(response).to redirect_to(game_url(game))
        end

        context 'with invalid parameters' do
          it "renders a successful response (i.e. to display the 'edit' template)" do
            game = create(:game, valid_attributes)

            call_action(game, { game: invalid_attributes })

            expect(response.status).to eq(422)
            expect(response).to render_template(:edit)
          end
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    def call_action(game = create(:game))
      delete game_url(game)
    end

    it_behaves_like 'not_logged_in'

    context 'when authenticated' do
      before { sign_in user }

      it 'destroys the requested game' do
        game = create(:game, valid_attributes)
        expect do
          call_action(game)
        end.to change(Game, :count).by(-1)
      end

      it 'redirects to the games list' do
        game = create(:game, valid_attributes)
        call_action(game)
        expect(response).to redirect_to(games_url)
      end
    end
  end
end
