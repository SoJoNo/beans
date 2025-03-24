Rails.application.routes.draw do
  # Static pages
  get 'about', to: 'pages#about'

  # Coffee shops resources
  resources :coffee_shops, only: [:index, :show] do
    resources :reviews, only: [:create]
  end

  # Coffee products resources
  resources :coffee_brands, only: [:index, :show]

  # Root path
  root 'coffee_shops#index'
end