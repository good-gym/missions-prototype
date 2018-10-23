Rails.application.routes.draw do
  root to: "home#index"
  get :todo, to: "home#todo"
  resource :sessions, only: %i[create destroy]

  resources :referrals
  resources :referrers
  resources :runners
  resources :availabilities
  resources :listings

  namespace :dashboards do
    resource :referrer do
      get :map
    end
    resource :runner do
      get :settings
    end
  end
  resources :dashboards do
    collection do
      get :map
    end
  end
end
