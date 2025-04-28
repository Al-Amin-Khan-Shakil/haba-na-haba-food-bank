Rails.application.routes.draw do
  devise_for :users,  skip: [:registrations]

  get 'home/index'
  resources :users
  resources :districts do
    resources :counties, only: [] do
      resources :sub_counties, only: []
    end
  end
  resources :branches

  # Conditional root route
  authenticated :user do
    root to: 'users#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'home#index', as: :unauthenticated_root
  end
end
