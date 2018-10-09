Rails.application.routes.draw do
  root to: "home#index"
  resource :sessions, only: %i[create destroy]
  resources :runners
  resources :availabilities
  resources :listings

  resources :dashboards do
    collection do
      get :map
      get :runner
    end
  end
end
