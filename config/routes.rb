Rails.application.routes.draw do
  root to: "home#index"
  get :todo, to: "home#todo"
  resource :sessions, only: %i[create destroy]

  resources :coordinators
  resources :referrers
  resources :runners

  resources :alerts
  resources :referrals do
    get :share
  end
  resources :reservations
  resources :availabilities

  resources :listings do
    collection { get :map }
  end

  resources :emails

  namespace :dashboards do
    namespace :coordinator do
      resources :referrals do
        member do
          patch :approve
          patch :reject
        end
      end
    end
    resource :coordinator, only: %i[show]

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
