Rails.application.routes.draw do
  # Root
  authenticated :user do
    root to: redirect('home'), as: :root_home
    get :home, to: 'home#index', as: :home
  end
  root to: 'welcome#index', as: :welcome

  # Devise routes
  devise_for :users,
             controllers:
             {
               omniauth_callbacks: 'users/omniauth_callbacks',
               registrations: 'users/registrations'

             }

  # Concerns
  concern :commentable do
    resources :comments, only: %i[index create destroy], concerns: :likeable
  end

  concern :likeable do
    resources :likes, only: %i[index create destroy]
  end

  # Users and nested resources
  resources :users, only: %i[show] do
    resources :status_updates, shallow: true, concerns: %i[commentable likeable]
    resource :profile, only: %i[edit update]
    post :set_avatar, to: 'profiles#set_avatar'
    post :set_cover, to: 'profiles#set_cover'
    resources :friendships, only: %i[index create update destroy]
    resources :photo_albums do
      resources :images, except: :new,
                         shallow: true,
                         concerns: %i[commentable likeable]
    end
  end

  # Notifications
  resources :notifications, only: :index do
    post 'mark_as_read', on: :collection
    post 'clear', on: :collection
  end

  # Autocomplete & Search
  get :autocomplete, to: 'autocomplete#index'

  namespace :autocomplete do
    get :friends
  end

  namespace :search do
    get :users, :status_updates, :images, :comments
  end

  # Email check
  get :check_email, to: 'users#check_email'

  # Conversations and messages
  resources :conversations, except: %i[edit create update] do
    get :unread_count, on: :collection
  end
  resources :messages, only: %i[create]
end
