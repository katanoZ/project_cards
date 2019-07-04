require 'rails_helper'

RSpec.describe CardSaveLogsCallbacks, type: :callback do
  let!(:user) { create(:user, name: '山田太郎') }
  let!(:project) { create(:project, owner: user) }
  let!(:column) { create(:column, project: project) }
  let!(:card) do
    create(:card, name: 'テスト', project: project, column: column,
                  due_date: '2019/01/01', assignee_id: user.id)
  end

  describe '#after_save' do
    context 'due_dateが変更された場合' do
      before { card.due_date = '2019/08/01' }

      context '操作者が設定されている場合' do
        before { card.operator = user }

        context '新しい期限を設定した場合' do
          before { card.due_date = '2019/08/01' }

          it 'ログが1件作成されること' do
            expect { card.save }.to change { Log.count }.by(1)
          end

          it 'ログの内容が正しいこと' do
            card.save
            log = Log.order(:created_at).last
            expect(log.content)
              .to eq '山田太郎さんがテストカードの期限を2019/08/01に設定しました'
            expect(log.project).to eq project
          end
        end

        context '期限をなしに設定した場合' do
          before { card.due_date = nil }

          it 'ログが1件作成されること' do
            expect { card.save }.to change { Log.count }.by(1)
          end

          it 'ログの内容が正しいこと' do
            card.save
            log = Log.order(:created_at).last
            expect(log.content)
              .to eq '山田太郎さんがテストカードの期限をなしに設定しました'
            expect(log.project).to eq project
          end
        end
      end

      context '操作者が設定されていない場合' do
        context '新しい期限を設定した場合' do
          before { card.due_date = '2019/08/01' }

          it 'ログが1件作成されること' do
            expect { card.save }.to change { Log.count }.by(1)
          end

          it 'ログの内容が正しいこと' do
            card.save
            log = Log.order(:created_at).last
            expect(log.content).to eq 'テストカードの期限が2019/08/01に設定されました'
            expect(log.project).to eq project
          end
        end

        context '期限をなしに設定した場合' do
          before { card.due_date = nil }

          it 'ログが1件作成されること' do
            expect { card.save }.to change { Log.count }.by(1)
          end

          it 'ログの内容が正しいこと' do
            card.save
            log = Log.order(:created_at).last
            expect(log.content).to eq 'テストカードの期限がなしに設定されました'
            expect(log.project).to eq project
          end
        end
      end
    end

    context 'assignee_idが変更された場合' do
      before do
        new_user = create(:user, name: '佐藤花子')
        new_user.participate_in(project)
        card.assignee_id = new_user.id
      end

      context '操作者が設定されている場合' do
        before { card.operator = user }

        it 'ログが1件作成されること' do
          expect { card.save }.to change { Log.count }.by(1)
        end

        it 'ログの内容が正しいこと' do
          card.save
          log = Log.order(:created_at).last
          expect(log.content)
            .to eq '山田太郎さんがテストカードを佐藤花子さんにアサインしました'
          expect(log.project).to eq project
        end
      end

      context '操作者が設定されていない場合' do
        it 'ログが1件作成されること' do
          expect { card.save }.to change { Log.count }.by(1)
        end

        it 'ログの内容が正しいこと' do
          card.save
          log = Log.order(:created_at).last
          expect(log.content).to eq 'テストカードが佐藤花子さんにアサインされました'
          expect(log.project).to eq project
        end
      end
    end

    context 'due_dateとassignee_idが変更された場合' do
      before do
        card.due_date = '2019/08/01'
        new_user = create(:user, name: '佐藤花子')
        new_user.participate_in(project)
        card.assignee_id = new_user.id
      end

      it 'ログが2件作成されること' do
        expect { card.save }.to change { Log.count }.by(2)
      end

      it 'ログの内容が正しいこと' do
        card.save
        due_date_log = project.logs.order(:created_at).second_to_last
        assignee_id_log = project.logs.order(:created_at).last

        expect(due_date_log.content)
          .to eq 'テストカードの期限が2019/08/01に設定されました'
        expect(assignee_id_log.content)
          .to eq 'テストカードが佐藤花子さんにアサインされました'
      end
    end
  end
end
