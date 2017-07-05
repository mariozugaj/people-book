Rails.application.routes.draw do
  authenticated :user do
    root to: 'home#index', as: :authenticated_root
  end
  root to: 'welcome#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    registrations: 'users/registrations'}

  resources :users, only: :show do
    resources :status_updates
    resource :profile, only: %i[show edit update]
  end
end
