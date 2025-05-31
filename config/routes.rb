Rails.application.routes.draw do
  devise_for :users,  skip: [:registrations]

  get 'home/index'
  get "dashboard", to: "dashboard#index"
  post '/ussd', to: 'ussd#recive'
  resources :users
  resources :branches

  resources :districts do
    resources :counties, only: [] do
      resources :sub_counties, only: []
    end
  end

  resources :requests do
    collection do
      get :load_counties
      get :load_sub_counties
    end

    resource :family_beneficiary, only: [:create, :new]
    resource :organization_beneficiary, only: [:create, :new]
    resource :individual_beneficiary, only: [:new, :create]
    resource :inventory, only: [:create, :new]
  end

  resources :individual_beneficiaries, only: [:index, :show, :destroy, :edit, :update]  do
    collection do
      get :load_counties
      get :load_sub_counties
    end
  end

  resources :family_beneficiaries, only: [:index, :show, :destroy, :edit, :update]  do
    collection do
      get :load_counties
      get :load_sub_counties
    end
  end

  resources :organization_beneficiaries, only: [:index, :show, :destroy, :edit, :update]  do
    collection do
      get :load_counties
      get :load_sub_counties
    end
  end

  resources :inventories, only: [:index, :show, :destroy, :edit, :update]  do
    collection do
      get :load_counties
      get :load_sub_counties
    end
  end

  resources :events do
    collection do
      get :load_counties
      get :load_sub_counties
    end

    resources :individual_beneficiaries, only: [:create, :new]
    resources :family_beneficiaries, only: [:create, :new]
    resources :organization_beneficiaries, only: [:create, :new]
    resources :inventories, only: [:create, :new]
  end

  # Conditional root route
  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'home#index', as: :unauthenticated_root
  end
end
