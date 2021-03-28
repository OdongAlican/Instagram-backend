# frozen_string_literal: true

Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'

  resources :conversations, only: %i[index create]
  resources :messagings, only: [:create]

  resources :users, only: %i[index show update] do
    post '/users/:id/follow', to: 'users#follow'
    post '/users/:id/unfollow', to: 'users#unfollow'
    get '/users/:id/nonfollow', to: 'users#peopleToFollow'
  end

  resources :posts, only: %i[index show create destroy] do
    resources :photos, only: [:create]
    resources :likes, only: %i[create destroy], shallow: true
    resources :comments, only: %i[index create destroy], shallow: true
    resources :bookmarks, only: %i[create destroy], shallow: true
  end
  mount ActionCable.server => '/cable'
end
