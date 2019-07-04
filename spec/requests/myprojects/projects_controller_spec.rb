require 'rails_helper'

RSpec.describe Myprojects::ProjectsController, type: :request do
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
            get myprojects_path
            expect(response.status).to eq 200
          end

          it 'html形式のレスポンスを返すこと' do
            get myprojects_path
            expect(response.content_type).to eq 'text/html'
          end

          it 'プロジェクト名が表示されること' do
            get myprojects_path
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
            get myprojects_path << '?page=2', xhr: true
            expect(response.status).to eq 200
          end

          it 'javascript形式のレスポンスを返すこと' do
            get myprojects_path << '?page=2', xhr: true
            expect(response.content_type).to eq 'text/javascript'
          end

          it 'プロジェクト名が表示されること' do
            # 1ページ目[10, 9, 8, 7, 6, 5, 4, 3, 2] 2ページ目[1]
            get myprojects_path << '?page=2', xhr: true
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
            get myprojects_path
            expect(response.status).to eq 200
          end

          it 'html形式のレスポンスを返すこと' do
            get myprojects_path
            expect(response.content_type).to eq 'text/html'
          end


          it 'プロジェクト名が表示されないこと' do
            get myprojects_path
            expect(response.body).not_to include 'テストプロジェクト'
          end
        end

        # 「もっと見る」ボタン（remote: true）押下
        context 'javascriptリクエストの場合' do
          before do
            1.upto(10) { |n| create(:project, name: "テストプロジェクト#{n}") }
          end

          it 'リクエストが成功すること' do
            get myprojects_path << '?page=2', xhr: true
            expect(response.status).to eq 200
          end

          it 'javascript形式のレスポンスを返すこと' do
            get myprojects_path << '?page=2', xhr: true
            expect(response.content_type).to eq 'text/javascript'
          end

          it 'プロジェクト名が表示されないこと' do
            get myprojects_path << '?page=2', xhr: true
            expect(response.body).not_to include 'テストプロジェクト'
          end
        end
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面にリダイレクトすること' do
        get myprojects_path
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET #new' do
    context 'ログイン済みの場合' do
      before do
        user = create(:user)
        login(user)
      end

      it 'リクエストが成功すること' do
        get new_myproject_path
        expect(response.status).to eq 200
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面にリダイレクトすること' do
        get new_myproject_path
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'POST #create' do
    context 'ログイン済みの場合' do
      before do
        user = create(:user)
        login(user)
      end

      context 'パラメータが妥当な場合' do
        let(:valid_params) { { project: attributes_for(:project) } }

        it 'リクエストが成功すること' do
          post myprojects_path, params: valid_params
          expect(response.status).to eq 302
        end

        it 'プロジェクトが登録されること' do
          expect do
            post myprojects_path, params: valid_params
          end.to change { Project.count }.by(1)
        end

        it '全プロジェクト一覧画面にリダイレクトすること' do
          post myprojects_path, params: valid_params
          expect(response).to redirect_to projects_path
        end
      end

      context 'パラメータが不正な場合' do
        let(:invalid_params) { { project: attributes_for(:project, :invalid) } }

        it 'リクエストが成功すること' do
          post myprojects_path, params: invalid_params
          expect(response.status).to eq 200
        end

        it 'プロジェクトが登録されないこと' do
          expect { post myprojects_path, params: invalid_params }
            .not_to(change { Project.count })
        end

        it 'エラーが表示されること' do
          post myprojects_path, params: invalid_params
          expect(response.body).to include 'を入力してください'
        end
      end
    end

    context '未ログインの場合' do
      it 'ログイン画面にリダイレクトすること' do
        get new_myproject_path
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET #edit' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before { login(user) }

      context 'ユーザにプロジェクトのアクセス権がある場合' do
        let!(:project) do
          create(:project, name: 'プロジェクトの名前',
                           summary: 'プロジェクトの概要',
                           owner: user)
        end

        it 'リクエストが成功すること' do
          get edit_myproject_path(project)
          expect(response.status).to eq 200
        end

        it 'プロジェクト内容が表示されていること' do
          get edit_myproject_path(project)
          expect(response.body).to include 'プロジェクトの名前'
          expect(response.body).to include 'プロジェクトの概要'
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let!(:project) { create(:project) }

        it 'レコードが存在しない例外が発生すること' do
          expect { get edit_myproject_path(project) }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      let!(:project) { create(:project) }

      it 'ログイン画面にリダイレクトすること' do
        get edit_myproject_path(project)
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before { login(user) }

      context 'ユーザにプロジェクトのアクセス権がある場合' do
        let!(:project) do
          create(:project, name: '名前変更前', summary: '概要変更前', owner: user)
        end

        context 'パラメータが妥当な場合' do
          let(:valid_params) do
            { project: attributes_for(:project, name: '名前変更後',
                                                summary: '概要変更後') }
          end

          it 'リクエストが成功すること' do
            patch myproject_path(project), params: valid_params
            expect(response.status).to eq 302
          end

          it 'プロジェクト名が更新されること' do
            expect { patch myproject_path(project), params: valid_params }
              .to change { Project.find(project.id).name }
              .from('名前変更前').to('名前変更後')
          end

          it 'プロジェクト概要が更新されること' do
            expect { patch myproject_path(project), params: valid_params }
              .to change { Project.find(project.id).summary }
              .from('概要変更前').to('概要変更後')
          end

          it '全プロジェクト一覧画面にリダイレクトすること' do
            patch myproject_path(project), params: valid_params
            expect(response).to redirect_to projects_path
          end
        end

        context 'パラメータが不正な場合' do
          let(:invalid_params) { { project: attributes_for(:project, :invalid) } }

          it 'リクエストが成功すること' do
            patch myproject_path(project), params: invalid_params
            expect(response.status).to eq 200
          end

          it 'プロジェクト名が変更されないこと' do
            expect { patch myproject_path(project), params: invalid_params }
              .not_to(change { Project.find(project.id).name })
          end

          it 'プロジェクト概要が変更されないこと' do
            expect { patch myproject_path(project), params: invalid_params }
              .not_to(change { Project.find(project.id).summary })
          end

          it 'エラーが表示されること' do
            patch myproject_path(project), params: invalid_params
            expect(response.body).to include 'を入力してください'
          end
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let!(:project) { create(:project) }

        context 'パラメータが妥当な場合' do
          let(:valid_params) { { project: attributes_for(:project) } }

          it 'レコードが存在しない例外が発生すること' do
            expect { patch myproject_path(project), params: valid_params }
              .to raise_error ActiveRecord::RecordNotFound
          end
        end

        context 'パラメータが不正な場合' do
          let(:invalid_params) { { project: attributes_for(:project, :invalid) } }

          it 'レコードが存在しない例外が発生すること' do
            expect { patch myproject_path(project), params: invalid_params }
              .to raise_error ActiveRecord::RecordNotFound
          end
        end
      end
    end

    context '未ログインの場合' do
      let!(:project) { create(:project) }
      let(:valid_params) { { project: attributes_for(:project) } }

      it 'ログイン画面にリダイレクトすること' do
        patch myproject_path(project), params: valid_params
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before { login(user) }

      context 'ユーザにプロジェクトのアクセス権がある場合' do
        let!(:project) { create(:project, owner: user) }

        it 'リクエストが成功すること' do
          delete myproject_path(project)
          expect(response.status).to eq 302
        end

        it 'プロジェクトが削除されること' do
          expect { delete myproject_path(project) }
            .to change { Project.count }.by(-1)
        end

        it '全プロジェクト一覧画面にリダイレクトすること' do
          delete myproject_path(project)
          expect(response).to redirect_to projects_path
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let!(:project) { create(:project) }

        it 'レコードが存在しない例外が発生すること' do
          expect { delete myproject_path(project) }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      let!(:project) { create(:project) }

      it 'ログイン画面にリダイレクトすること' do
        delete myproject_path(project)
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end
end
