require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  describe 'GET #new' do
    context 'ログイン済みの場合' do
      before do
        user = create(:user)
        login(user)
      end

      it 'リクエストが成功すること' do
        get login_path
        expect(response.status).to eq 200
      end
    end

    context '未ログインの場合' do
      it 'リクエストが成功すること' do
        get login_path
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET #create' do
    let(:user) { create(:user) }

    context 'ログイン済みの場合' do
      before do
        login(user)

        # .find_or_create_from_authは単体テストで検証済みのため内容を検証しない
        allow(User).to receive(:find_or_create_from_auth).and_return(user)
      end

      it 'リクエストが成功すること' do
        get '/auth/:provider/callback', params: { provider: user.provider }
        expect(response.status).to eq 302

        # Userモデルに対する処理が行われたこと
        expect(User).to have_received(:find_or_create_from_auth).once
      end

      it 'セッションの値が作成されること' do
        get '/auth/:provider/callback', params: { provider: user.provider }
        expect(session[:user_id]).to eq user.id
      end

      it 'トップ画面にリダイレクトすること' do
        get '/auth/:provider/callback', params: { provider: user.provider }
        expect(response).to redirect_to root_path
      end
    end

    context '未ログインの場合' do
      before do
        # .find_or_create_from_authは単体テストで検証済みのため内容を検証しない
        allow(User).to receive(:find_or_create_from_auth).and_return(user)
      end

      it 'リクエストが成功すること' do
        get '/auth/:provider/callback', params: { provider: user.provider }
        expect(response.status).to eq 302

        # Userモデルに対する処理が行われたこと
        expect(User).to have_received(:find_or_create_from_auth).once
      end

      it 'セッションの値が作成されること' do
        get '/auth/:provider/callback', params: { provider: user.provider }
        expect(session[:user_id]).to eq user.id
      end

      it 'トップ画面にリダイレクトすること' do
        get '/auth/:provider/callback', params: { provider: user.provider }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET #destroy' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before { login(user) }

      it 'リクエストが成功すること' do
        get logout_path
        expect(response.status).to eq 302
      end

      it 'セッションの値が削除されること' do
        get logout_path
        expect(session[:user_id]).to eq nil
      end

      it 'ログイン画面にリダイレクトすること' do
        get logout_path
        expect(response).to redirect_to login_path
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面にリダイレクトすること' do
        get logout_path
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end
end
