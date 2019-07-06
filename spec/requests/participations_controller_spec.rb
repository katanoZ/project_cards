require 'rails_helper'

RSpec.describe ParticipationsController, type: :request do
  describe 'POST #create' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before { login(user) }

      context 'ユーザが招待されているプロジェクトの場合' do
        let(:project) { create(:project) }
        before { project.invite(user) }

        it 'リクエストが成功すること' do
          post project_participations_path(project)
          expect(response.status).to eq 302
        end

        it '対象のユーザが参加すること' do
          expect do
            post project_participations_path(project)
          end.to change { user.member?(project) }.from(false).to(true)
        end

        it 'プロジェクト詳細画面にリダイレクトすること' do
          post project_participations_path(project)
          expect(response).to redirect_to project_path(project)
        end
      end

      context 'ユーザが招待されていないプロジェクトの場合' do
        context 'ユーザがプロジェクトオーナーの場合' do
          let(:project) { create(:project, owner: user) }

          it 'レコードが存在しない例外が発生すること' do
            expect { post project_participations_path(project) }
              .to raise_error ActiveRecord::RecordNotFound
          end
        end

        context 'ユーザがプロジェクトメンバーの場合' do
          let(:project) { create(:project) }
          before { user.participate_in(project) }

          it 'レコードが存在しない例外が発生すること' do
            expect { post project_participations_path(project) }
              .to raise_error ActiveRecord::RecordNotFound
          end
        end

        context 'ユーザがプロジェクトと無関係の場合' do
          let(:project) { create(:project) }

          it 'レコードが存在しない例外が発生すること' do
            expect { post project_participations_path(project) }
              .to raise_error ActiveRecord::RecordNotFound
          end
        end
      end
    end

    context '未ログインの場合' do
      let(:project) { create(:project) }

      it 'ログイン画面にリダイレクトすること' do
        post project_participations_path(project)
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end
end
