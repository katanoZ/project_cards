Rails.application.routes.draw do
  root 'projects#index'

  get 'login', to: 'sessions#new'
  get 'auth/:provider/callback', to: 'sessions#create'

  # マイページ
  resource :user, path: 'mypage', as: 'mypage', only: %i[show edit update]
end
