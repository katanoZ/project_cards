require 'rails_helper'

RSpec.describe ColumnsController, type: :request do
  describe 'GET #new' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before  { login(user) }

      context 'ユーザにプロジェクトのアクセス権がある場合' do
        let(:project) { create(:project, owner: user) }

        it 'リクエストが成功すること' do
          get new_project_column_path(project)
          expect(response.status).to eq 200
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let(:project) { create(:project) }

        it 'レコードが存在しない例外が発生すること' do
          expect { get new_project_column_path(project) }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      let(:project) { create(:project) }

      it 'ログイン画面にリダイレクトすること' do
        get new_project_column_path(project)
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'POST #create' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before  { login(user) }

      context 'ユーザにプロジェクトのアクセス権がある場合' do
        let(:project) { create(:project, owner: user) }

        context 'パラメータが妥当な場合' do
          let(:valid_params) { { column: attributes_for(:column) } }

          it 'リクエストが成功すること' do
            post project_columns_path(project), params: valid_params
            expect(response.status).to eq 302
          end

          it 'カラムが登録されること' do
            expect do
              post project_columns_path(project), params: valid_params
            end.to change { Column.count }.by(1)
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            post project_columns_path(project), params: valid_params
            expect(response).to redirect_to project_path(project)
          end
        end

        context 'パラメータが不正な場合' do
          let(:invalid_params) { { column: attributes_for(:column, :invalid) } }

          it 'リクエストが成功すること' do
            post project_columns_path(project), params: invalid_params
            expect(response.status).to eq 200
          end

          it 'プロジェクトが登録されないこと' do
            expect do
              post project_columns_path(project), params: invalid_params
            end.not_to(change { Column.count })
          end

          it 'エラーが表示されること' do
            post project_columns_path(project), params: invalid_params
            expect(response.body).to include 'を入力してください'
          end
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let(:project) { create(:project) }
        let(:valid_params) { { column: attributes_for(:column) } }

        it 'レコードが存在しない例外が発生すること' do
          expect { post project_columns_path(project), params: valid_params }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      let(:project) { create(:project) }
      let(:valid_params) { { column: attributes_for(:column) } }

      it 'ログイン画面にリダイレクトすること' do
        post project_columns_path(project), params: valid_params

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
        let!(:project) { create(:project, owner: user) }
        let!(:column) { create(:column, project: project, name: 'テストカラム') }

        it 'リクエストが成功すること' do
          get edit_project_column_path(project, column)
          expect(response.status).to eq 200
        end

        it 'カラム名が表示されていること' do
          get edit_project_column_path(project, column)
          expect(response.body).to include 'テストカラム'
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let!(:project) { create(:project) }
        let!(:column) { create(:column, project: project) }

        it 'レコードが存在しない例外が発生すること' do
          expect { get edit_project_column_path(project, column) }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      let!(:project) { create(:project) }
      let!(:column) { create(:column, project: project) }

      it 'ログイン画面にリダイレクトすること' do
        get edit_project_column_path(project, column)
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
        let!(:project) { create(:project, owner: user) }
        let!(:column) { create(:column, project: project, name: '名前変更前') }

        context 'パラメータが妥当な場合' do
          let(:valid_params) do
            { column: attributes_for(:column, name: '名前変更後') }
          end

          it 'リクエストが成功すること' do
            patch project_column_path(project, column), params: valid_params
            expect(response.status).to eq 302
          end

          it 'カラム名が更新されること' do
            expect do
              patch project_column_path(project, column), params: valid_params
            end.to change { Column.find(column.id).name }
              .from('名前変更前').to('名前変更後')
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            patch project_column_path(project, column), params: valid_params
            expect(response).to redirect_to project_path(project)
          end
        end

        context 'パラメータが不正な場合' do
          let(:invalid_params) { { column: attributes_for(:column, :invalid) } }

          it 'リクエストが成功すること' do
            patch project_column_path(project, column), params: invalid_params
            expect(response.status).to eq 200
          end

          it 'カラム名が変更されないこと' do
            expect do
              patch project_column_path(project, column), params: invalid_params
            end.not_to(change { Column.find(column.id).name })
          end

          it 'エラーが表示されること' do
            patch project_column_path(project, column), params: invalid_params
            expect(response.body).to include 'を入力してください'
          end
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let!(:project) { create(:project) }
        let!(:column) { create(:column, project: project) }

        context 'パラメータが妥当な場合' do
          let(:valid_params) { { column: attributes_for(:column) } }

          it 'レコードが存在しない例外が発生すること' do
            expect do
              patch project_column_path(project, column), params: valid_params
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end

        context 'パラメータが不正な場合' do
          let(:invalid_params) { { column: attributes_for(:column, :invalid) } }

          it 'レコードが存在しない例外が発生すること' do
            expect do
              patch project_column_path(project, column), params: invalid_params
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end
      end
    end

    context '未ログインの場合' do
      let!(:project) { create(:project) }
      let!(:column) { create(:column, project: project) }
      let(:valid_params) { { column: attributes_for(:column) } }

      it 'ログイン画面にリダイレクトすること' do
        patch project_column_path(project, column), params: valid_params
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
        let!(:column) { create(:column, project: project) }

        it 'リクエストが成功すること' do
          delete project_column_path(project, column)
          expect(response.status).to eq 302
        end

        it 'プロジェクトが削除されること' do
          expect { delete project_column_path(project, column) }
            .to change { Column.count }.from(1).to(0)
        end

        it 'プロジェクト詳細画面にリダイレクトすること' do
          delete project_column_path(project, column)
          expect(response).to redirect_to project_path(project)
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let!(:project) { create(:project) }
        let!(:column) { create(:column, project: project) }

        it 'レコードが存在しない例外が発生すること' do
          expect { delete project_column_path(project, column) }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      let!(:project) { create(:project) }
      let!(:column) { create(:column, project: project) }

      it 'ログイン画面にリダイレクトすること' do
        delete project_column_path(project, column)
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET previous' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before  { login(user) }

      context 'ユーザにプロジェクトのアクセス権がある場合' do
        let!(:project) { create(:project, owner: user) }
        before { create_list(:column, 3, project: project) }

        context 'カラムが移動可能な位置にある場合' do
          let(:column) { project.columns.last }

          it 'リクエストが成功すること' do
            get previous_project_column_path(project, column)
            expect(response.status).to eq 302
          end

          it 'カラムが1つ前に移動すること' do
            expect { get previous_project_column_path(project, column) }
              .to change { Column.find(column.id).position }.by(-1)
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            get previous_project_column_path(project, column)
            expect(response).to redirect_to project_path(project)
          end
        end

        context 'カラムが移動可能な位置にない場合' do
          let(:column) { project.columns.first }

          it 'リクエストが成功すること' do
            get previous_project_column_path(project, column)
            expect(response.status).to eq 302
          end

          it 'カラムが移動しないこと' do
            expect { get previous_project_column_path(project, column) }
              .not_to(change { Column.find(column.id).position })
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            get previous_project_column_path(project, column)
            expect(response).to redirect_to project_path(project)
          end
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        before { create_list(:column, 3, project: project) }
        let!(:project) { create(:project) }
        let(:column) { project.columns.last }

        it 'レコードが存在しない例外が発生すること' do
          expect { get previous_project_column_path(project, column) }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      before { create_list(:column, 3, project: project) }
      let!(:project) { create(:project) }
      let(:column) { project.columns.last }

      it 'ログイン画面にリダイレクトすること' do
        get previous_project_column_path(project, column)
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET next' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before  { login(user) }

      context 'ユーザにプロジェクトのアクセス権がある場合' do
        let!(:project) { create(:project, owner: user) }
        before { create_list(:column, 3, project: project) }

        context 'カラムが移動可能な位置にある場合' do
          let(:column) { project.columns.first }

          it 'リクエストが成功すること' do
            get next_project_column_path(project, column)
            expect(response.status).to eq 302
          end

          it 'カラムが1つ後ろに移動すること' do
            expect { get next_project_column_path(project, column) }
              .to change { Column.find(column.id).position }.by(1)
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            get next_project_column_path(project, column)
            expect(response).to redirect_to project_path(project)
          end
        end

        context 'カラムが移動可能な位置にない場合' do
          let(:column) { project.columns.last }

          it 'リクエストが成功すること' do
            get next_project_column_path(project, column)
            expect(response.status).to eq 302
          end

          it 'カラムが移動しないこと' do
            expect { get next_project_column_path(project, column) }
              .not_to(change { Column.find(column.id).position })
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            get next_project_column_path(project, column)
            expect(response).to redirect_to project_path(project)
          end
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        before { create_list(:column, 3, project: project) }
        let!(:project) { create(:project) }
        let(:column) { project.columns.first }

        it 'レコードが存在しない例外が発生すること' do
          expect { get next_project_column_path(project, column) }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      before { create_list(:column, 3, project: project) }
      let!(:project) { create(:project) }
      let(:column) { project.columns.first }

      it 'ログイン画面にリダイレクトすること' do
        get next_project_column_path(project, column)
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end
end
