Rails.application.routes.draw do
  get 'quotes/index'
  get 'quotes/create'
  get 'health_check', to: 'home#health_check'
  get 'signup', to: 'users#new'
  get 'users', to: 'users#create'
  get 'terms', to: 'static_pages#terms', as: :terms
  get 'likes', to: 'likes#index', as: :user_likes
  get 'privacy_policy', to: 'static_pages#privacy_policy', as: :privacy_policy
  get    'login',  to: 'sessions#new'
  post   'login',  to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :users, only: [:new, :create, :show, :edit, :update]
  resources :quotes, only: [:new, :index, :create, :show, :destroy, :edit, :update] do
    resources :likes, only: [:create, :destroy]
    collection do
      get :search
      get :search_result
    end
  end
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "quotes#index"
end
