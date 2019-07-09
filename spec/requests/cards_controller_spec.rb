require 'rails_helper'

RSpec.describe CardsController, type: :request do
  describe 'GET #new' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before  { login(user) }

      context 'ユーザにプロジェクトのアクセス権がある場合' do
        let(:project) { create(:project, owner: user) }
        let(:column) { create(:column, project: project) }

        it 'リクエストが成功すること' do
          get new_project_column_card_path(project, column)
          expect(response.status).to eq 200
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let(:project) { create(:project) }
        let(:column) { create(:column, project: project) }

        it 'レコードが存在しない例外が発生すること' do
          expect { get new_project_column_card_path(project, column) }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      let(:project) { create(:project) }
      let(:column) { create(:column, project: project) }

      it 'ログイン画面にリダイレクトすること' do
        get new_project_column_card_path(project, column)
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
        let(:column) { create(:column, project: project) }

        context 'パラメータが妥当な場合' do
          let(:valid_params) do
            { card: attributes_for(:card, column: column) }
          end

          it 'リクエストが成功すること' do
            post project_column_cards_path(project, column),
                 params: valid_params
            expect(response.status).to eq 302
          end

          it 'カードが登録されること' do
            expect do
              post project_column_cards_path(project, column),
                   params: valid_params
            end.to change { Card.count }.by(1)
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            post project_column_cards_path(project, column),
                 params: valid_params
            expect(response).to redirect_to project_path(project)
          end
        end

        context 'パラメータが不正な場合' do
          let(:invalid_params) do
            { card: attributes_for(:card, column: column, name: nil) }
          end

          it 'リクエストが成功すること' do
            post project_column_cards_path(project, column),
                 params: invalid_params
            expect(response.status).to eq 200
          end

          it 'カードが登録されないこと' do
            expect do
              post project_column_cards_path(project, column),
                   params: invalid_params
            end.not_to(change { Card.count })
          end

          it 'エラーが表示されること' do
            post project_column_cards_path(project, column),
                 params: invalid_params
            expect(response.body).to include 'を入力してください'
          end
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let(:project) { create(:project) }
        let(:column) { create(:column, project: project) }
        let(:valid_params) { { column: attributes_for(:card, column: column) } }

        it 'レコードが存在しない例外が発生すること' do
          expect do
            post project_column_cards_path(project, column),
                 params: valid_params
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      let(:project) { create(:project) }
      let(:column) { create(:column, project: project) }
      let(:valid_params) { { column: attributes_for(:card, column: column) } }

      it 'ログイン画面にリダイレクトすること' do
        post project_column_cards_path(project, column), params: valid_params

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
        let!(:column) { create(:column, project: project) }
        let!(:card) { create(:card, column: column, name: 'テストカード') }

        it 'リクエストが成功すること' do
          get edit_project_column_card_path(project, column, card)
          expect(response.status).to eq 200
        end

        it 'カード名が表示されていること' do
          get edit_project_column_card_path(project, column, card)
          expect(response.body).to include 'テストカード'
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let!(:project) { create(:project) }
        let!(:column) { create(:column, project: project) }
        let!(:card) { create(:card, column: column) }

        it 'レコードが存在しない例外が発生すること' do
          expect { get edit_project_column_card_path(project, column, card) }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      let!(:project) { create(:project) }
      let!(:column) { create(:column, project: project) }
      let!(:card) { create(:card, column: column) }

      it 'ログイン画面にリダイレクトすること' do
        get edit_project_column_card_path(project, column, card)
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
        let!(:column) { create(:column, project: project) }
        let!(:card) { create(:card, column: column, name: '名前変更前') }

        context 'パラメータが妥当な場合' do
          let(:valid_params) do
            { card: attributes_for(:card, column: column, name: '名前変更後') }
          end

          it 'リクエストが成功すること' do
            patch project_column_card_path(project, column, card),
                  params: valid_params
            expect(response.status).to eq 302
          end

          it 'カード名が更新されること' do
            expect do
              patch project_column_card_path(project, column, card),
                    params: valid_params
            end.to change { Card.find(card.id).name }
              .from('名前変更前').to('名前変更後')
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            patch project_column_card_path(project, column, card),
                  params: valid_params
            expect(response).to redirect_to project_path(project)
          end
        end

        context 'パラメータが不正な場合' do
          let(:invalid_params) do
            { card: attributes_for(:card, column: column, name: nil) }
          end

          it 'リクエストが成功すること' do
            patch project_column_card_path(project, column, card),
                  params: invalid_params
            expect(response.status).to eq 200
          end

          it 'カード名が変更されないこと' do
            expect do
              patch project_column_card_path(project, column, card),
                    params: invalid_params
            end.not_to(change { Card.find(card.id).name })
          end

          it 'エラーが表示されること' do
            patch project_column_card_path(project, column, card),
                  params: invalid_params
            expect(response.body).to include 'を入力してください'
          end
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let!(:project) { create(:project) }
        let!(:column) { create(:column, project: project) }
        let!(:card) { create(:card, column: column) }

        context 'パラメータが妥当な場合' do
          let(:valid_params) { { card: attributes_for(:card, column: column) } }

          it 'レコードが存在しない例外が発生すること' do
            expect do
              patch project_column_card_path(project, column, card),
                    params: valid_params
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end

        context 'パラメータが不正な場合' do
          let(:invalid_params) do
            { card: attributes_for(:card, column: column, name: nil ) }
          end

          it 'レコードが存在しない例外が発生すること' do
            expect do
              patch project_column_card_path(project, column, card),
                    params: invalid_params
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end
      end
    end

    context '未ログインの場合' do
      let!(:project) { create(:project) }
      let!(:column) { create(:column, project: project) }
      let!(:card) { create(:card, column: column) }
      let(:valid_params) { { card: attributes_for(:card, column: column) } }

      it 'ログイン画面にリダイレクトすること' do
        patch project_column_card_path(project, column, card),
              params: valid_params
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
        let!(:card) { create(:card, column: column) }

        it 'リクエストが成功すること' do
          delete project_column_card_path(project, column, card)
          expect(response.status).to eq 302
        end

        it 'カードが削除されること' do
          expect { delete project_column_card_path(project, column, card) }
            .to change { Card.count }.from(1).to(0)
        end

        it 'プロジェクト詳細画面にリダイレクトすること' do
          delete project_column_card_path(project, column, card)
          expect(response).to redirect_to project_path(project)
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        let!(:project) { create(:project) }
        let!(:column) { create(:column, project: project) }
        let!(:card) { create(:card, column: column) }

        it 'レコードが存在しない例外が発生すること' do
          expect { delete project_column_card_path(project, column, card) }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      let!(:project) { create(:project) }
      let!(:column) { create(:column, project: project) }
      let!(:card) { create(:card, column: column) }

      it 'ログイン画面にリダイレクトすること' do
        delete project_column_card_path(project, column, card)
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET previous' do
    let(:card) { create(:card, column: column) }

    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before  { login(user) }

      context 'ユーザにプロジェクトのアクセス権がある場合' do
        let!(:project) { create(:project, owner: user) }
        before { create_list(:column, 3, project: project) }

        context 'カードが移動可能な位置にある場合' do
          let(:column) { project.columns.last }

          it 'リクエストが成功すること' do
            get previous_project_column_card_path(project, column, card)
            expect(response.status).to eq 302
          end

          it 'カードが1つ前のカラム先頭に移動すること' do
            expect do
              get previous_project_column_card_path(project, column, card)
            end.to change { card.reload.column.position }.by(-1)
            expect(card.position).to eq 1
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            get previous_project_column_card_path(project, column, card)
            expect(response).to redirect_to project_path(project)
          end
        end

        context 'カードが移動可能な位置にない場合' do
          let(:column) { project.columns.first }

          it 'リクエストが成功すること' do
            get previous_project_column_card_path(project, column, card)
            expect(response.status).to eq 302
          end

          it 'カードのカラム位置が移動しないこと' do
            expect do
              get previous_project_column_card_path(project, column, card)
            end.not_to(change { card.reload.column.position })
          end

          it 'カードの位置が移動しないこと' do
            expect do
              get previous_project_column_card_path(project, column, card)
            end.not_to(change { card.reload.position })
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            get previous_project_column_card_path(project, column, card)
            expect(response).to redirect_to project_path(project)
          end
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        before { create_list(:column, 3, project: project) }
        let!(:project) { create(:project) }
        let(:column) { project.columns.last }

        it 'レコードが存在しない例外が発生すること' do
          expect do
            get previous_project_column_card_path(project, column, card)
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      before { create_list(:column, 3, project: project) }
      let!(:project) { create(:project) }
      let(:column) { project.columns.last }

      it 'ログイン画面にリダイレクトすること' do
        get previous_project_column_card_path(project, column, card)
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET next' do
    let(:card) { create(:card, column: column) }

    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before  { login(user) }

      context 'ユーザにプロジェクトのアクセス権がある場合' do
        let!(:project) { create(:project, owner: user) }
        before { create_list(:column, 3, project: project) }

        context 'カードが移動可能な位置にある場合' do
          let(:column) { project.columns.first }

          it 'リクエストが成功すること' do
            get next_project_column_card_path(project, column, card)
            expect(response.status).to eq 302
          end

          it 'カードが1つ後ろのカラム先頭に移動すること' do
            expect { get next_project_column_card_path(project, column, card) }
              .to change { card.reload.column.position }.by(1)
            expect(card.position).to eq 1
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            get next_project_column_card_path(project, column, card)
            expect(response).to redirect_to project_path(project)
          end
        end

        context 'カードが移動可能な位置にない場合' do
          let(:column) { project.columns.last }

          it 'リクエストが成功すること' do
            get next_project_column_card_path(project, column, card)
            expect(response.status).to eq 302
          end

          it 'カードのカラム位置が移動しないこと' do
            expect { get next_project_column_card_path(project, column, card) }
              .not_to(change { card.reload.column.position })
          end

          it 'カードの位置が移動しないこと' do
            expect { get next_project_column_card_path(project, column, card) }
              .not_to(change { card.reload.position })
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            get next_project_column_card_path(project, column, card)
            expect(response).to redirect_to project_path(project)
          end
        end
      end

      context 'ユーザにプロジェクトのアクセス権がない場合' do
        before { create_list(:column, 3, project: project) }
        let!(:project) { create(:project) }
        let(:column) { project.columns.first }

        it 'レコードが存在しない例外が発生すること' do
          expect { get next_project_column_card_path(project, column, card) }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context '未ログインの場合' do
      before { create_list(:column, 3, project: project) }
      let!(:project) { create(:project) }
      let(:column) { project.columns.first }

      it 'ログイン画面にリダイレクトすること' do
        get next_project_column_card_path(project, column, card)
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end
end
