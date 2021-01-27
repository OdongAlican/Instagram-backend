# frozen_string_literal: true

Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
  resources :users, only: %i[show update]

  resources :posts, only: %i[index show create] do
    resources :photos, only: [:create]
  end
end
