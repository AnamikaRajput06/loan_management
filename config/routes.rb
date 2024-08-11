require 'sidekiq/web'

Rails.application.routes.draw do
  root to: "loans#index"

  mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app
  resource :session, controller: "clearance/sessions", only: [:create]

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  resources :loans, only: [:create, :new, :index, :destroy, :edit] do
    member do
      patch :approve
      patch :reject
      patch :accept
      patch :pay
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
