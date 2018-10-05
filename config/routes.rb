Rails.application.routes.draw do
  root to: "home#index"
  resource :sessions, only: %i[create destroy]
  resources :runners
  resources :availabilities

  resources :dashboards do
    collection do
      get :runner
    end
  end
end
