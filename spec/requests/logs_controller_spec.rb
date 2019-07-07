require 'rails_helper'

RSpec.describe LogsController, type: :request do
  describe 'GET #index' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before { login(user) }

      context 'ユーザにプロジェクトのアクセス権がある場合' do
        let(:project) { create(:project, owner: user) }
        before do
          1.upto(2) do |n|
            create(:log, project: project, content: "テストログ#{n}")
          end
        end

        it 'リクエストが成功すること' do
          get project_logs_path(project)
          expect(response.status).to eq 200
        end

        it 'ログが表示されること' do
          get project_logs_path(project)
          expect(response.body).to include 'テストログ1'
          expect(response.body).to include 'テストログ2'
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let(:project) { create(:project) }

        it 'レコードが存在しない例外が発生すること' do
          expect { get project_logs_path(project) }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      let(:project) { create(:project) }

      it 'ログイン画面にリダイレクトすること' do
        get project_logs_path(project)
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end
end
