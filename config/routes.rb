Rails.application.routes.draw do
  # Root
  authenticated :user do
    root to: 'home#index', as: :authenticated_root
  end
  root to: 'welcome#index'

  # Devise routes
  devise_for :users,
             controllers:
             {
               omniauth_callbacks: 'users/omniauth_callbacks',
               registrations: 'users/registrations'
             }

  # Concerns
  concern :commentable do
    resources :comments, only: %i[create destroy], concerns: :likeable
  end

  concern :likeable do
    resources :likes, only: %i[create destroy]
  end

  # Users and nested resources
  resources :users, only: :show do
    resources :status_updates, shallow: true, concerns: %i[commentable likeable]
    resource :profile, only: %i[edit update]
    resources :friendships, only: %i[index create update destroy]
  end
end
