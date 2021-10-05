# frozen_string_literal: true

Rails.application.routes.draw do
  get 'pages/index'
  root to: 'pages#index'

  get 'sign_up', to: 'registrations#new'
  post 'sign_up', to: 'registrations#create'

  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create', as: 'log_in'
  delete 'logout', to: 'sessions#destroy'

  get 'password', to: 'passwords#edit', as: 'edit_password'
  patch 'password', to: 'passwords#update'

  get 'password/reset', to: 'passwords_reset#new'
  post 'password/reset', to: 'passwords_reset#create'
  get 'password/reset/edit', to: 'passwords_reset#edit'
  patch 'password/reset/edit', to: 'passwords_reset#update'
end
