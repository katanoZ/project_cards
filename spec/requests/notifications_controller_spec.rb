require 'rails_helper'

RSpec.describe NotificationsController, type: :request do
  describe 'GET #index' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before { login(user) }

      context 'httpリクエストの場合' do
        before do
          project = create(:project, name: 'テストプロジェクト')
          create(:invitation, user: user, project: project)
        end

        it 'リクエストが成功すること' do
          get notifications_path
          expect(response.status).to eq 200
        end

        it 'html形式のレスポンスを返すこと' do
          get notifications_path
          expect(response.content_type).to eq 'text/html'
        end

        it '通知が表示されること' do
          get notifications_path
          expect(response.body)
            .to include 'あなたをプロジェクト「テストプロジェクト」に招待しています'
        end
      end

      # 「もっと見る」ボタン（remote: true）押下
      context 'javascriptリクエストの場合' do
        let(:params) { { page: 2 } }
        before do
          1.upto(6) do |n|
            project = create(:project, name: "テストプロジェクト#{n}")
            create(:invitation, user: user, project: project)
          end
        end

        it 'リクエストが成功すること' do
          get notifications_path, params: params, xhr: true
          expect(response.status).to eq 200
        end

        it 'javascript形式のレスポンスを返すこと' do
          get notifications_path, params: params, xhr: true
          expect(response.content_type).to eq 'text/javascript'
        end

        it '通知が表示されること' do
          # 1ページ目[6, 5, 4, 3, 2] 2ページ目[1]
          get notifications_path, params: params, xhr: true
          expect(response.body)
            .to include 'あなたをプロジェクト「テストプロジェクト1」に招待しています'
        end
      end
    end

    context '未ログインの場合' do

      it 'ログイン画面にリダイレクトすること' do
        get notifications_path
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end
end
