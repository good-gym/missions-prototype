Rails.application.routes.draw do
  root to: "home#index"
  get :todo, to: "home#todo"
  resource :sessions, only: %i[create destroy]

  resources :coordinators
  resources :referrers
  resources :runners

  resources :alerts
  resources :referrals
  resources :reservations
  resources :availabilities
  resources :listings

  resources :emails

  namespace :dashboards do
    namespace :coordinator do
      root to: "coordinators#show"
      resources :referrals do
        member do
          patch :approve
          patch :reject
        end
      end
    end

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
