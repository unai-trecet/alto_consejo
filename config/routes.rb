# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#dashboard'
  get 'dashboard', to: 'pages#dashboard'

  get 'welcome', to: 'pages#welcome'

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
end
