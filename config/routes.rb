Rails.application.routes.draw do
  root 'projects#index'

  # ログインページ
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  get 'auth/:provider/callback', to: 'sessions#create'

  # マイページ
  resource :mypage, controller: :users,
                    only: %i[show edit update destroy]

  # 全プロジェクト
  resources :projects, only: %i[index show]

  # マイプロジェクト
  resources :myprojects, controller: :projects, module: :myprojects,
                         only: %i[index new create edit update destroy]
end
