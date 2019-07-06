require 'rails_helper'

RSpec.describe InvitationsController, type: :request do
  describe 'GET #invite' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before { login(user) }

      context 'ユーザがプロジェクトオーナーの場合' do
        let(:project) { create(:project, owner: user) }

        it 'リクエストが成功すること' do
          get project_invite_path(project)
          expect(response.status).to eq 200
        end
      end

      context 'ユーザがプロジェクトオーナーでない場合' do
        let(:project) { create(:project) }

        context 'ユーザがプロジェクトのメンバーの場合' do
          before { user.participate_in(project) }

          it 'レコードが存在しない例外が発生すること' do
            expect { get project_invite_path(project) }
              .to raise_error ActiveRecord::RecordNotFound
          end
        end

        context 'ユーザがプロジェクトに招待されている場合' do
          before { project.invite(user) }

          it 'レコードが存在しない例外が発生すること' do
            expect { get project_invite_path(project) }
              .to raise_error ActiveRecord::RecordNotFound
          end
        end

        context 'ユーザがプロジェクトと無関係の場合' do
          it 'レコードが存在しない例外が発生すること' do
            expect { get project_invite_path(project) }
              .to raise_error ActiveRecord::RecordNotFound
          end
        end
      end
    end

    context '未ログインの場合' do
      let(:project) { create(:project) }

      it 'ログイン画面にリダイレクトすること' do
        get project_invite_path(project)
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET #generate_invitaions' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before { login(user) }

      context 'ユーザがプロジェクトオーナーの場合' do
        let(:project) { create(:project, owner: user) }

        context 'パラメータがある場合' do
          before { create(:user, name: 'テスト太郎') }
          let(:params) { { invitation: { name: '太郎' } } }

          it 'リクエストが成功すること' do
            get project_generate_invitaions_path(project), params: params
            expect(response.status).to eq 200
          end

          it 'ユーザ名が表示されること' do
            get project_generate_invitaions_path(project), params: params
            expect(response.body).to include 'テスト太郎'
          end
        end

        context 'パラメータがない場合' do
          it 'パラメータがない例外が発生すること' do
            expect { get project_generate_invitaions_path(project) }
              .to raise_error ActionController::ParameterMissing
          end
        end
      end

      context 'ユーザがプロジェクトオーナーでない場合' do
        let(:project) { create(:project) }
        let(:params) { { invitation: { name: '太郎' } } }

        context 'ユーザがプロジェクトのメンバーの場合' do
          before { user.participate_in(project) }

          it 'レコードが存在しない例外が発生すること' do
            expect do
              get project_generate_invitaions_path(project), params: params
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end

        context 'ユーザがプロジェクトに招待されている場合' do
          before { project.invite(user) }

          it 'レコードが存在しない例外が発生すること' do
            expect do
              get project_generate_invitaions_path(project), params: params
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end

        context 'ユーザがプロジェクトと無関係の場合' do
          it 'レコードが存在しない例外が発生すること' do
            expect do
              get project_generate_invitaions_path(project), params: params
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end
      end
    end

    context '未ログインの場合' do
      let(:project) { create(:project) }
      let(:params) { { invitation: { name: '太郎' } } }

      it 'ログイン画面にリダイレクトすること' do
        get project_generate_invitaions_path(project), params: params
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'POST #create' do
    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      before { login(user) }

      context 'ユーザがプロジェクトオーナーの場合' do
        let(:project) { create(:project, owner: user) }

        context 'パラメータが妥当な場合' do
          let(:invitee) { create(:user) }
          let(:valid_params) { { user_id: invitee.id } }

          it 'リクエストが成功すること' do
            post project_invitations_path(project), params: valid_params
            expect(response.status).to eq 302
          end

          it '対象のユーザが招待されること' do
            expect do
              post project_invitations_path(project), params: valid_params
            end.to change { invitee.invited?(project) }.from(false).to(true)
          end

          it 'プロジェクト詳細画面にリダイレクトすること' do
            post project_invitations_path(project), params: valid_params
            expect(response).to redirect_to project_path(project)
          end
        end

        context 'パラメータが不正な場合' do
          let(:invalid_params) { { user_id: invitee.id } }

          context '招待対象のユーザがプロジェクト参加済みの場合' do
            let(:invitee) { create(:user) }
            before { invitee.participate_in(project) }

            it 'リクエストが成功すること' do
              post project_invitations_path(project), params: invalid_params
              expect(response.status).to eq 302
            end

            it '対象のユーザが招待されないこと' do
              expect do
                post project_invitations_path(project), params: invalid_params
              end.not_to(change { Invitation.count })
            end

            it 'プロジェクト詳細画面にリダイレクトすること' do
              post project_invitations_path(project), params: invalid_params
              expect(response).to redirect_to project_path(project)
            end
          end

          context '招待対象のユーザがプロジェクトオーナーの場合' do
            let(:invitee) { user }

            it 'リクエストが成功すること' do
              post project_invitations_path(project), params: invalid_params
              expect(response.status).to eq 302
            end

            it '対象のユーザが招待されないこと' do
              expect do
                post project_invitations_path(project), params: invalid_params
              end.not_to(change { Invitation.count })
            end

            it 'プロジェクト詳細画面にリダイレクトすること' do
              post project_invitations_path(project), params: invalid_params
              expect(response).to redirect_to project_path(project)
            end
          end
        end
      end

      context 'ユーザがプロジェクトオーナーでない場合' do
        let(:project) { create(:project) }
        let(:invitee) { create(:user) }
        let(:valid_params) { { user_id: invitee.id } }

        context 'ユーザがプロジェクトのメンバーの場合' do
          before { user.participate_in(project) }

          it 'レコードが存在しない例外が発生すること' do
            expect do
              post project_invitations_path(project), params: valid_params
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end

        context 'ユーザがプロジェクトに招待されている場合' do
          before { project.invite(user) }

          it 'レコードが存在しない例外が発生すること' do
            expect do
              post project_invitations_path(project), params: valid_params
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end

        context 'ユーザがプロジェクトと無関係の場合' do
          it 'レコードが存在しない例外が発生すること' do
            expect do
              post project_invitations_path(project), params: valid_params
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end
      end
    end

    context '未ログインの場合' do
      let(:project) { create(:project) }
      let(:invitee) { create(:user) }
      let(:valid_params) { { user_id: invitee.id } }

      it 'ログイン画面にリダイレクトすること' do
        post project_invitations_path(project), params: valid_params
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
    end
  end
end
