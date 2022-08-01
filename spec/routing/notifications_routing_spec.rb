# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/notifications').to route_to('notifications#index')
    end

    it 'routes to #new' do
      expect(get: '/notifications/new').to route_to('notifications#new')
    end

    it 'routes to #show' do
      expect(get: '/notifications/1').to route_to('notifications#show', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/notifications/1').to route_to('notifications#destroy', id: '1')
    end
  end
end
