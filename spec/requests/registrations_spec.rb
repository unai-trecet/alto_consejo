require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  describe 'GET /sign_up' do
    it 'renders new template' do
      get '/sign_up'

      expect(response).to have_http_status(200)
      expect(response).to render_template('registrations/new')
    end
  end

  describe 'POST /sign_up' do
    context 'correct params' do
      let(:valid_params) do
        { user: { email: 'test1@test.com', password: '123456' } }
      end

      it 'creates a new user' do
        expect { post '/sign_up', params: valid_params }
          .to change(User, :count).from(0).to(1)

        created_user = User.last

        expect(created_user.email).to eq('test1@test.com')
      end

      it 'redirects to root_path' do
        post '/sign_up', params: valid_params

        expect(response).to redirect_to(root_path)
      end
    end

    context 'incorrect params' do
      # we pass an invalid email
      let(:invalid_params) do
        { user: { email: 'test1#test.com', password: '123456' } }
      end

      it 'renders new template without creating an user' do
        expect { post '/sign_up', params: invalid_params }
          .not_to change(User, :count)

        expect(response).to render_template(:new)
      end
    end
  end
end
