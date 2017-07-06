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

  # Users and nesting resources
  resources :users, only: :show do
    resources :status_updates, shallow: true
    resource :profile, only: %i[show edit update]
  end
end
