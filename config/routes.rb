Rails.application.routes.draw do
  root 'projects#index'

  # ログインページ
  controller :sessions do
    get 'login', action: :new
    get 'logout', action: :destroy
    get 'auth/:provider/callback', action: :create
  end

  # マイページ
  resource :mypage, controller: :users,
                    only: %i[show edit update destroy]

  # 全プロジェクト
  resources :projects, only: %i[index show] do
    resources :columns, only: %i[new create edit update destroy] do
      get 'previous', on: :member
      get 'next', on: :member
      resources :cards, only: %i[new create edit update destroy] do
        get 'previous', on: :member
        get 'next', on: :member
      end
    end

    # 招待
    controller :invitations do
      get 'invite', action: :invite
      resources :invitations, only: %i[index create]
    end
  end

  # マイプロジェクト
  resources :myprojects, controller: :projects, module: :myprojects,
                         only: %i[index new create edit update destroy]

  # お知らせ
  resources :notifications, only: %i[index]
end
