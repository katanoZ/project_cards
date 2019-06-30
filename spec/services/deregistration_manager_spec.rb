require 'rake_helper'

RSpec.describe DeregistrationManager, type: :service do
  describe 'destroy_user!' do
    let(:user) { create(:user, name: '削除対象') }
    let(:manager) { DeregistrationManager.new(user) }

    context '削除対象ユーザがプロジェクトのオーナーの場合' do
      let(:project) { create(:project, owner: user) }

      context 'プロジェクトにメンバーがいる場合' do
        let(:oldest_menber) { create(:user, name: '最古') }
        before do
          oldest_menber.participate_in(project)
          create_list(:participation, 3, project: project)
        end

        it '結果が正しいこと' do
          expect(manager.destroy_user!).to be_truthy
        end

        it 'ユーザが削除されること' do
          id = user.id
          manager.destroy_user!
          expect(User.exists?(id)).to be_falsy
        end

        it 'プロジェクトオーナーが最古の参加メンバーに交代していること' do
          manager.destroy_user!
          project.reload
          expect(project.owner).to eq oldest_menber
        end

        it 'ログが2件作成されること' do
          expect { manager.destroy_user! }.to change { Log.count }.by(2)
        end

        it '1件目のログの内容が正しいこと' do
          manager.destroy_user!

          log = Log.order(:created_at).second_to_last
          expected = 'プロジェクトオーナーの削除対象さんが退会するため、'\
                     '最古メンバーの最古さんが新しくオーナーになりました'
          expect(log.content).to eq expected
          expect(log.project).to eq project
        end

        it '2件目のログの内容が正しいこと' do
          manager.destroy_user!

          log = Log.order(:created_at).last
          expect(log.content).to eq '削除対象さんが退会しました'
          expect(log.project).to eq project
        end
      end

      context 'プロジェクトにメンバーがいない場合' do
        # 無関係のプロジェクトにメンバーを作成
        before { create_list(:participation, 3) }

        it '結果が正しいこと' do
          expect(manager.destroy_user!).to be_truthy
        end

        it 'ユーザが削除されること' do
          id = user.id
          manager.destroy_user!
          expect(User.exists?(id)).to be_falsy
        end

        it 'プロジェクトが削除されること' do
          id = project.id
          manager.destroy_user!
          expect(Project.exists?(id)).to be_falsy
        end

        it 'ログが作成されないこと' do
          expect { manager.destroy_user! }.not_to(change { Log.count })
        end
      end
    end

    context '削除対象ユーザがプロジェクトのメンバーの場合' do
      let(:project) { create(:project) }
      before { user.participate_in(project) }

      it '結果が正しいこと' do
        expect(manager.destroy_user!).to be_truthy
      end

      it 'ユーザが削除されること' do
        id = user.id
        manager.destroy_user!
        expect(User.exists?(id)).to be_falsy
      end

      it 'プロジェクトが削除されないこと' do
        id = project.id
        manager.destroy_user!
        expect(Project.exists?(id)).to be_truthy
      end

      it 'ログが1件作成されること' do
        expect { manager.destroy_user! }.to change { Log.count }.by(1)
      end

      it 'ログの内容が正しいこと' do
        manager.destroy_user!

        log = Log.order(:created_at).last
        expect(log.content).to eq '削除対象さんが退会しました'
        expect(log.project).to eq project
      end
    end

    context '処理対象のプロジェクトが複数ある場合' do
      # 1:処理対象/削除対象ユーザがオーナーのプロジェクト（メンバーあり）
      let(:owner_project1) { create(:project, owner: user) }
      let(:oldest_menber) { create(:user, name: '最古') }
      before do
        oldest_menber.participate_in(owner_project1)
        create_list(:participation, 3, project: owner_project1)
      end

      # 2:処理対象/削除対象ユーザがオーナーのプロジェクト（メンバーなし）
      let(:owner_project2) { create(:project, owner: user) }
      # 無関係のプロジェクトにメンバーを作成
      before { create_list(:participation, 3) }

      # 3:処理対象外/削除対象ユーザがメンバーのプロジェクト
      let(:member_project) { create(:project) }
      before { user.participate_in(member_project) }

      it '結果が正しいこと' do
        expect(manager.destroy_user!).to be_truthy
      end

      it 'ユーザが削除されること' do
        id = user.id
        manager.destroy_user!
        expect(User.exists?(id)).to be_falsy
      end

      it 'メンバーのいるオーナーのプロジェクトはオーナー交代していること' do
        manager.destroy_user!
        owner_project1.reload
        expect(owner_project1.owner).to eq oldest_menber
      end

      it 'オーナ交代したプロジェクトのログが2件作成されること' do
        expect { manager.destroy_user! }
          .to change { owner_project1.logs.count }.by(2)
      end

      it 'メンバーのいないオーナーのプロジェクトは削除されること' do
        id = owner_project2.id
        manager.destroy_user!
        expect(Project.exists?(id)).to be_falsy
      end

      it 'メンバーのいないオーナーのプロジェクトのログは作成されないこと' do
        expect { manager.destroy_user! }
          .not_to(change { owner_project2.logs.count })
      end

      it 'メンバーのプロジェクトは削除されないこと' do
        id = member_project.id
        manager.destroy_user!
        expect(Project.exists?(id)).to be_truthy
      end

      it 'メンバーのプロジェクトのログが1件作成されること' do
        expect { manager.destroy_user! }
          .to change { member_project.logs.count }.by(1)
      end

      it 'ログが全体で3件作成されること' do
        expect { manager.destroy_user! }.to change { Log.count }.by(3)
      end
    end

    context '削除対象ユーザがオーナーまたはメンバーのプロジェクトがない場合' do
      # ユーザと関係がないプロジェクトと参加者を作成
      let(:project) { create(:project) }
      before { create_list(:participation, 3, project: project) }

      it '結果が正しいこと' do
        expect(manager.destroy_user!).to be_truthy
      end

      it 'ユーザが削除されること' do
        id = user.id
        manager.destroy_user!
        expect(User.exists?(id)).to be_falsy
      end

      it 'プロジェクトが削除されないこと' do
        expect { manager.destroy_user! }.not_to(change { Project.count })
      end

      it 'ログが作成されないこと' do
        expect { manager.destroy_user! }.not_to(change { Log.count })
      end
    end
  end
end
