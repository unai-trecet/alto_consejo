require 'rails_helper'

RSpec.describe 'Errors', type: :request do
  describe 'GET /404' do
    it 'returns http not found status' do
      expect { get '/non_existent_path' }.to raise_error(ActionController::RoutingError)
    end
  end
end
