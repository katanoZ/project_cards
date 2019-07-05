require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'GET #show' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user, name: 'テスト名前') }
      before { login(user) }

      it 'リクエストが成功すること' do
        get mypage_path
        expect(response.status).to eq 200
      end

      it 'ユーザ名が表示されること' do
        get mypage_path
        expect(response.body).to include 'テスト名前'
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面にリダイレクトすること' do
        get mypage_path
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET #edit' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user, name: 'テスト名前') }
      before { login(user) }

      it 'リクエストが成功すること' do
        get edit_mypage_path
        expect(response.status).to eq 200
      end

      it 'ユーザ名が表示されていること' do
        get edit_mypage_path
        expect(response.body).to include 'テスト名前'
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面にリダイレクトすること' do
        get edit_mypage_path
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user, name: '名前変更前') }
      before { login(user) }

      context 'パラメータが妥当な場合' do
        let(:valid_params) { { user: attributes_for(:user, name: '名前変更後') } }

        it 'リクエストが成功すること' do
          patch mypage_path, params: valid_params
          expect(response.status).to eq 302
        end

        it 'ユーザ名が更新されること' do
          expect { patch mypage_path, params: valid_params }
            .to change { User.find(user.id).name }
            .from('名前変更前').to('名前変更後')
        end

        it 'トップ画面にリダイレクトすること' do
          patch mypage_path, params: valid_params
          expect(response).to redirect_to root_path
        end
      end

      context 'パラメータが不正な場合' do
        let(:invalid_params) { { user: attributes_for(:user, :invalid) } }

        it 'リクエストが成功すること' do
          patch mypage_path, params: invalid_params
          expect(response.status).to eq 200
        end

        it 'ユーザ名が変更されないこと' do
          expect { patch mypage_path, params: invalid_params }
            .not_to(change { User.find(user.id).name })
        end

        it 'エラーが表示されること' do
          patch mypage_path, params: invalid_params
          expect(response.body).to include 'を入力してください'
        end
      end
    end

    context '未ログインの場合' do
      let(:valid_params) { { user: attributes_for(:user) } }

      it 'ログイン画面にリダイレクトすること' do
        patch mypage_path, params: valid_params
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before { login(user) }

      it 'リクエストが成功すること' do
        delete mypage_path
        expect(response.status).to eq 302
      end

      it 'ユーザが削除されること' do
        expect { delete mypage_path }
          .to change { User.count }.from(1).to(0)
      end

      it 'ログイン画面にリダイレクトすること' do
        delete mypage_path
        expect(response).to redirect_to login_path
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面にリダイレクトすること' do
        delete mypage_path
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end
end
