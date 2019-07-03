require 'rails_helper'

RSpec.describe ProjectsController, type: :request do
  describe 'GET #index' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before { login(user) }

      context 'ユーザにプロジェクトのアクセス権がある場合' do
        context 'httpリクエストの場合' do
          before do
            1.upto(2) do |n|
              create(:project, name: "テストプロジェクト#{n}", owner: user)
            end
          end

          it 'リクエストが成功すること' do
            get projects_path
            expect(response.status).to eq 200
          end

          it 'html形式のレスポンスを返すこと' do
            get projects_path
            expect(response.content_type).to eq 'text/html'
          end

          it 'プロジェクト名が表示されること' do
            get projects_path
            expect(response.body).to include 'テストプロジェクト1'
            expect(response.body).to include 'テストプロジェクト2'
          end
        end

        # 「もっと見る」ボタン（remote: true）押下
        context 'javascriptリクエストの場合' do
          before do
            1.upto(10) do |n|
              create(:project, name: "テストプロジェクト#{n}", owner: user)
            end
          end

          it 'リクエストが成功すること' do
            get projects_path << '?page=2', xhr: true
            expect(response.status).to eq 200
          end

          it 'javascript形式のレスポンスを返すこと' do
            get projects_path << '?page=2', xhr: true
            expect(response.content_type).to eq 'text/javascript'
          end

          it 'プロジェクト名が表示されること' do
            # 1ページ目[10, 9, 8, 7, 6, 5, 4, 3, 2] 2ページ目[1]
            get projects_path << '?page=2', xhr: true
            expect(response.body).to include 'テストプロジェクト1'
          end
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        context 'httpリクエストの場合' do
          before do
            1.upto(2) { |n| create(:project, name: "テストプロジェクト#{n}") }
          end

          it 'リクエストが成功すること' do
            get projects_path
            expect(response.status).to eq 200
          end

          it 'html形式のレスポンスを返すこと' do
            get projects_path
            expect(response.content_type).to eq 'text/html'
          end

          it 'プロジェクト名が表示されること' do
            get projects_path
            expect(response.body).to include 'テストプロジェクト1'
            expect(response.body).to include 'テストプロジェクト2'
          end
        end

        # 「もっと見る」ボタン（remote: true）押下
        context 'javascriptリクエストの場合' do
          before do
            1.upto(10) { |n| create(:project, name: "テストプロジェクト#{n}") }
          end

          it 'リクエストが成功すること' do
            get projects_path << '?page=2', xhr: true
            expect(response.status).to eq 200
          end

          it 'javascript形式のレスポンスを返すこと' do
            get projects_path << '?page=2', xhr: true
            expect(response.content_type).to eq 'text/javascript'
          end

          it 'プロジェクト名が表示されること' do
            # 1ページ目[10, 9, 8, 7, 6, 5, 4, 3, 2] 2ページ目[1]
            get projects_path << '?page=2', xhr: true
            expect(response.body).to include 'テストプロジェクト1'
          end
        end
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面にリダイレクトすること' do
        get projects_path
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET #show' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before { login(user) }

      context 'ユーザにプロジェクトのアクセス権がある場合' do
        let(:project) { create(:project, name: 'テストプロジェクト', owner: user) }

        before do
          column = create(:column, project: project, name: 'テストカラム')
          create(:card, project: project, column: column, name: 'テストカード')
        end

        it 'リクエストが成功すること' do
          get project_path(project)
          expect(response.status).to eq 200
        end

        it 'プロジェクト、カラム、カード名が表示されること' do
          get project_path(project)
          expect(response.body).to include 'テストプロジェクト'
          expect(response.body).to include 'テストカラム'
          expect(response.body).to include 'テストカード'
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let(:project) { create(:project) }

        it 'レコードが存在しない例外が発生すること' do
          expect { get project_path(project) }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      let(:project) { create(:project) }

      it 'ログイン画面にリダイレクトすること' do
        get project_path(project)
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET #info' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user, name: 'テストユーザ') }
      before { login(user) }

      context 'ユーザにプロジェクトのアクセス権がある場合' do
        let(:project) do
          create(:project, name: 'テストプロジェクト', owner: user)
        end

        before do
          member = create(:user, name: 'テストメンバー')
          member.participate_in(project)
        end

        it 'リクエストが成功すること' do
          get project_info_path(project)
          expect(response.status).to eq 200
        end

        it 'プロジェクト内容が表示されること' do
          get project_info_path(project)
          expect(response.body).to include 'テストプロジェクト'
          expect(response.body).to include 'テストユーザ'
          expect(response.body).to include 'テストメンバー'
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let(:project) { create(:project) }

        it 'レコードが存在しない例外が発生すること' do
          expect { get project_info_path(project) }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      let(:project) { create(:project) }

      it 'ログイン画面にリダイレクトすること' do
        get project_info_path(project)
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end
end
