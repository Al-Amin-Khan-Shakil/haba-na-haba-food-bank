Rails.application.routes.draw do
  devise_for :users,  skip: [:registrations]

  get 'home/index'
  resources :users

  # Conditional root route
  authenticated :user do
    root to: 'users#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'home#index', as: :unauthenticated_root
  end
end
