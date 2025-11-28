Rails.application.routes.draw do
  devise_for :users,
            path: "",
            path_names: {
              sign_in: "login",
              sign_out: "logout",
              registration: "signup"
            },
            controllers: {
              sessions: "users/sessions",
              registrations: "users/registrations"
            }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :warehouses
    resources :products
    resources :stocks, only: [ :index, :show ]
    get "stocks/by_warehouse/:warehouse_id", to: "stocks#by_warehouse"
    get "stocks/by_product/:product_id", to: "stocks#by_product"
    resources :inventory_movements, only: [ :index, :show ]
    post "inventory/entry", to: "inventory_movements#register_entry"
    post "inventory/exit", to: "inventory_movements#register_exit"
    post "inventory/transfer", to: "inventory_movements#register_transfer"
    get "inventory/history/:product_id", to: "inventory_movements#movement_history"
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
