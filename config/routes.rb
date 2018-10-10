Rails.application.routes.draw do
  root to: "home#index"
  get :todo, to: "home#todo"
  resource :sessions, only: %i[create destroy]

  resources :referrals
  resources :referrers
  resources :runners
  resources :availabilities
  resources :listings

  resources :dashboards do
    collection do
      get :map
      get :runner
      get :referrer
    end
  end
end
