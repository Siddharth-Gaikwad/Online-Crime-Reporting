Rails.application.routes.draw do
  resources :case_reports do
    collection do
      get :solved
      get :pending
    end
  end

  resources :branches do
    collection do
      get :nearest   # /branches/nearest?lat=..&lon=..
    end
  end

  devise_for :admin, controllers: {
    sessions: 'admins/sessions',
    registrations: 'admins/registrations'
  }

  devise_for :police, controllers: {
    sessions: 'police/sessions',
    registrations: 'police/registrations'
  }

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root 'pages#home'
  get 'pages/users'
  get 'pages/admin'
  get 'pages/police'

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # For users
  authenticate :user do
    resources :case_reports, only: [:index, :show, :create, :edit, :destroy] 
  end

  # For police
  authenticate :police do
    resources :case_reports, only: [:index, :show, :edit, :update]
  end
end
