Rails.application.routes.draw do
  # Devise & ActiveAdmin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # 静的ページ
  get 'terms', to: 'static_pages#terms', as: :terms
  get 'privacy_policy', to: 'static_pages#privacy_policy', as: :privacy_policy

  # ヘルスチェック
  get 'health_check', to: 'home#health_check'
  get 'up', to: 'rails/health#show', as: :rails_health_check

  # 認証
  get    'signup', to: 'users#new'    # フレンドリーなURL用
  get    'login',  to: 'sessions#new'
  post   'login',  to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # オートコンプリート
  get '/autocomplete', to: 'autocomplete#index'

  # 一般ユーザー関連
  resources :users, only: [:new, :create, :show, :edit, :update]

  # 投稿（名言）関連
  resources :quotes, only: [:new, :index, :create, :show, :destroy, :edit, :update] do
    collection do
      get :search
      get :search_result
    end

    resources :likes, only: [:create, :destroy]
    resources :reports, only: [:new, :create], defaults: { reportable: 'Quote' }
    resources :comments, only: [:create]
  end

  # コメント通報用
  resources :comments, only: [] do
    resources :reports, only: [:new, :create], defaults: { reportable: 'Comment' }
  end

  # ユーザーがいいねした投稿一覧
  get 'likes', to: 'likes#index', as: :user_likes

  # ホーム
  get 'home/index'  # 使っていれば残してOK（使ってなければ削除可能）

  # ルート
  root 'quotes#index'
end
