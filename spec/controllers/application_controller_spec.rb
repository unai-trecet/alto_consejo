# frozen_string_literal: true

require 'rails_helper'

class DummyController < ApplicationController
  def edit
    render plain: 'OK'
  end

  def update
    render plain: 'OK'
  end

  def destroy
    render plain: 'OK'
  end
end

RSpec.describe DummyController, type: :controller do
  let(:user) { create(:user, :confirmed) }
  let(:admin) { create(:user, :admin) }
  let(:another_user) { create(:user, :confirmed) }
  let(:resource) { create(:game, user:) } # replace with your actual resource

  describe '#authorize_user' do
    before do
      allow(controller).to receive(:set_resource) { controller.instance_variable_set(:@resource, resource) }
    end

    around do |example|
      Rails.application.routes.draw do
        resources :dummy
        get '403', to: 'error_pages#unauthorized', as: :unauthorized
      end
      example.run
      Rails.application.routes_reloader.reload!
    end

    describe 'GET #edit' do
      context 'when user owns the resource' do
        before { sign_in user }

        it 'sets the resource' do
          get :edit, params: { id: resource.id }
          expect(assigns(:resource)).to eq(resource)
        end

        it 'allows the action' do
          get :edit, params: { id: resource.id }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when user is an admin' do
        before { sign_in admin }

        it 'sets the resource' do
          get :edit, params: { id: resource.id }
          expect(assigns(:resource)).to eq(resource)
        end

        it 'allows the action' do
          get :edit, params: { id: resource.id }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when user is not authorized' do
        before { sign_in another_user }

        it 'redirects to unauthorized path' do
          get :edit, params: { id: resource.id }
          expect(response).to redirect_to('/403')
        end
      end
    end

    describe 'PUT #update' do
      context 'when user owns the resource' do
        before { sign_in user }

        it 'sets the resource' do
          put :update, params: { id: resource.id }
          expect(assigns(:resource)).to eq(resource)
        end

        it 'allows the action' do
          put :update, params: { id: resource.id }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when user is an admin' do
        before { sign_in admin }

        it 'sets the resource' do
          put :update, params: { id: resource.id }
          expect(assigns(:resource)).to eq(resource)
        end

        it 'allows the action' do
          put :update, params: { id: resource.id }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when user is not authorized' do
        before { sign_in another_user }

        it 'redirects to unauthorized path' do
          put :update, params: { id: resource.id }
          expect(response).to redirect_to(unauthorized_path)
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'when user owns the resource' do
        before { sign_in user }

        it 'sets the resource' do
          delete :destroy, params: { id: resource.id }
          expect(assigns(:resource)).to eq(resource)
        end

        it 'allows the action' do
          delete :destroy, params: { id: resource.id }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when user is an admin' do
        before { sign_in admin }

        it 'sets the resource' do
          delete :destroy, params: { id: resource.id }
          expect(assigns(:resource)).to eq(resource)
        end

        it 'allows the action' do
          delete :destroy, params: { id: resource.id }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when user is not authorized' do
        before { sign_in another_user }

        it 'redirects to unauthorized path' do
          delete :destroy, params: { id: resource.id }
          expect(response).to redirect_to(unauthorized_path)
        end
      end
    end
  end
end
