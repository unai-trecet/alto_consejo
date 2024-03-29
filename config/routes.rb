# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#dashboard'
  get 'dashboard', to: 'pages#dashboard'

  get 'welcome', to: 'pages#welcome'

  get '403', to: 'error_pages#unauthorized', as: :unauthorized

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

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

  resources :comments do
    resources :comments, module: :comments
    member do
      patch :upvote
    end
  end

  resources :friendships, only: %i[create update destroy]

  resources :matches do
    member do
      delete 'purge_image'
    end
    resources :comments, module: :matches
  end

  resources :games do
    resources :reviews, only: %i[index create edit update destroy], module: :games
    resources :comments, module: :games
    member do
      delete 'purge_main_image'
    end
  end

  resources :match_participants, only: %i[create destroy]
  resources :match_invitations, only: %i[create destroy]
  resources :notifications, only: %i[index show new create destroy]
  resources :users, only: %i[index show edit update] do
    resources :reviews, only: %i[index], module: :users
    member do
      delete 'purge_avatar'
    end
    resources :comments, module: :users
  end
  resources :ratings, only: %i[create update]

  patch 'like', to: 'likes#like'
  get 'matches_calendar', to: 'calendars#matches_calendar'
  get 'username_search', to: 'users#username_search'
  get 'search_game_name', to: 'games#search_game_name'
  delete 'attachments/:id/purge', to: 'attachments#purge', as: :purge_attachment

  get 'graphs/user_played_matches', to: 'graphs#user_played_matches'
  get 'graphs/user_organized_matches', to: 'graphs#user_organized_matches'
end
