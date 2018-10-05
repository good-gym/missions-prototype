Rails.application.routes.draw do
  root to: "home#index"

  resource :sessions, only: %i[create destroy]
  resources :runners
  resources :availabilities
end
