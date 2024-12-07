Rails.application.routes.draw do
  get 'districts/index'
  get 'districts/new'
  devise_for :users,  skip: [:registrations]

  get 'home/index'
  resources :users
  resources :districts do
    resources :counties, only: [:create, :destroy]
    resources :sub_counties, only: [:create, :destroy]
  end

  # Conditional root route
  authenticated :user do
    root to: 'users#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'home#index', as: :unauthenticated_root
  end
end
