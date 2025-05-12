Rails.application.routes.draw do

  devise_for :users,  skip: [:registrations]

  get 'home/index'
  post '/ussd', to: 'ussd#recive'
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

    resources :family_beneficiaries, only: [:create, :new]
    resources :organization_beneficiaries, only: [:create, :new]
    resource :individual_beneficiary, only: [:new, :create]

  end
  resources :individual_beneficiaries, only: [:index, :show, :destroy, :edit, :update]  do
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
  
  # Conditional root route
  authenticated :user do
    root to: 'users#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'home#index', as: :unauthenticated_root
  end
end
