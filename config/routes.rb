# frozen_string_literal: true

Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
  resources :users, only: %i[index show update]

  resources :posts, only: %i[index show create destroy] do
    resources :photos, only: [:create]
    resources :likes, only: %i[create destroy], shallow: true
    resources :comments, only: %i[index create destroy], shallow: true
    resources :bookmarks, only: %i[create destroy], shallow: true
  end
end
