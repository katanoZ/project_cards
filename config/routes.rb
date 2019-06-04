Rails.application.routes.draw do
  root 'projects#index'

  # ログインページ
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  get 'auth/:provider/callback', to: 'sessions#create'

  # マイページ
  resource :user, path: 'mypage', as: 'mypage', only: %i[show edit update]
end
