Rails.application.routes.draw do
  get 'family_beneficiaries/index'
  get 'family_beneficiaries/show'
  get 'family_beneficiaries/new'
  get 'family_beneficiaries/edit'
  get 'family_beneficiaries/create'
  get 'family_beneficiaries/update'
  get 'family_beneficiaries/destroy'
  devise_for :users,  skip: [:registrations]

  get 'home/index'
  resources :users
  resources :districts do
    resources :counties, only: [] do
      resources :sub_counties, only: []
    end
  end
  resources :branches
  resources :requests do
    collection do
      get :load_counties
      get :load_sub_counties
    end
    resources :family_beneficiaries
    resources :organization_beneficiaries
  end
  resources :events do
    collection do
      get :load_counties
      get :load_sub_counties
    end
  end
  resources :family_beneficiaries, only: [:index, :show, :destroy, :edit, :update, :create]  do
    collection do
      get :load_counties
      get :load_sub_counties
    end
  end
  resources :organization_beneficiaries, only: [:index, :show, :destroy, :edit, :update, :create]  do
    collection do
      get :load_counties
      get :load_sub_counties
    end
  end
  # Conditional root route
  authenticated :user do
    root to: 'users#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'home#index', as: :unauthenticated_root
  end
end
