Rails.application.routes.draw do
  # テスト用LINE送信エンドポイント
  get 'line_test/send_test_message', to: 'line_test#send_test_message'

  # Devise & ActiveAdmin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }, path_names: {
    line_omniauth_authorize: 'auth/line',
    passwords: 'users/passwords'
  }

  delete '/unlink_line_account', to: 'users#unlink_line_account', as: :unlink_line_account

  authenticated :user do
    root 'quotes#index', as: :authenticated_root
  end
  unauthenticated do
    root 'home#index', as: :unauthenticated_root
  end

  # LINE Webhook
  post '/callback', to: 'line_webhook#callback'

  # 静的ページ
  get 'terms', to: 'static_pages#terms', as: :terms
  get 'privacy_policy', to: 'static_pages#privacy_policy', as: :privacy_policy

  # ヘルスチェック
  get 'health_check', to: 'home#health_check'
  get 'up', to: 'rails/health#show', as: :rails_health_check

  # オートコンプリート
  get '/autocomplete', to: 'autocomplete#index'

  # 一般ユーザー関連
  resources :users, only: [:new, :create, :show, :edit, :update, :registration]

  # 投稿（名言）関連
  resources :quotes, only: [:new, :index, :create, :show, :destroy, :edit, :update] do
    collection do
      get :search
      get :search_result
    end

    resources :likes, only: [:create, :destroy]
    resources :reports, only: [:new, :create], defaults: { reportable: 'Quote' }
    resources :comments, only: [:create]

    # コメント通報用
    resources :comments, only: [] do
      resources :reports, only: [:new, :create], defaults: { reportable: 'Comment' }
    end
  end

  # ユーザーがいいねした投稿一覧
  get 'likes', to: 'likes#index', as: :user_likes

  # ランキング
  resources :rankings, only: [] do
    collection do
      get :total_likes
      get :weekly_likes
    end
  end

  # ホーム
  get 'home/index'

  # ルート
  root 'quotes#index'
end
