# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#dashboard'
  get 'dashboard', to: 'pages#dashboard'

  get 'welcome', to: 'pages#welcome'

  get 'autocomplete', to: 'pages#autocomplete'

  get '403', to: 'error_pages#unauthorized', as: :unauthorized

  devise_for :admins,
             path: 'admin_auth',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               password: 'secret',
               confirmation: 'verification',
               registration: 'register',
               sign_up: 'cmon_let_me_in'
             },
             controllers: {
               confirmations: 'admins/confirmations',
               passwords: 'admins/passwords',
               registrations: 'admins/registrations',
               sessions: 'admins/sessions'
             }

  devise_for :users,
             path: 'auth',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               password: 'secret',
               confirmation: 'verification',
               registration: 'register',
               sign_up: 'cmon_let_me_in'
             },
             controllers: {
               confirmations: 'users/confirmations',
               passwords: 'users/passwords',
               registrations: 'users/registrations',
               sessions: 'users/sessions'
             }

  resources :games
  resources :games do
    resources :comments, module: :games
  end
  resources :matches do
    resources :comments, module: :matches
  end
  resources :comments do
    resources :comments, module: :comments
  end

  resources :users, only: %i[index show edit update]
  resources :match_participants, only: %i[create destroy]
  resources :match_invitations, only: %i[create destroy]
  resources :notifications, only: %i[index show new create destroy]

  get 'matches_calendar', to: 'calendars#matches_calendar', as: :matches_calendar
end
