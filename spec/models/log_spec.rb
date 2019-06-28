require 'rails_helper'

RSpec.describe Log, type: :model do
  describe '.create_due_date_notification_logs!' do
    let!(:project) { create(:project) }
    let!(:column) { create(:column, project: project) }

    context 'ログ出力条件に該当するデータがある場合' do
      context '本日が期限のカードがある場合' do
        let!(:card) do
          create(:card, project: project, column: column,
                        due_date: Date.today, name: 'テスト')
        end

        it '結果が正しいこと' do
          expect { Log.create_due_date_notification_logs! }
            .to change { Log.count }.by(1)
        end

        it '内容が正しいこと' do
          Log.create_due_date_notification_logs!
          expect(Log.last.content).to eq '本日がテストカードの締切期限です'
          expect(Log.last.project).to eq project
        end
      end

      context '期限を過ぎたカードがある場合' do
        let!(:card) do
          create(:card, project: project, column: column,
                        due_date: Date.today - 3.days, name: 'テスト')
        end

        it '結果が正しいこと' do
          expect { Log.create_due_date_notification_logs! }
            .to change { Log.count }.by(1)
        end

        it '内容が正しいこと' do
          Log.create_due_date_notification_logs!
          expect(Log.last.content).to eq 'テストカードの締切期限が3日過ぎました'
          expect(Log.last.project).to eq project
        end
      end
    end

    context 'ログ出力条件に該当するデータがない場合' do
      let!(:card) do
        create(:card, project: project, column: column,
                      due_date: Date.today + 3.days, name: 'テスト')
      end

      it '結果が正しいこと' do
        expect { Log.create_due_date_notification_logs! }
          .not_to(change { Log.count })
      end
    end

    context 'ログ出力条件に該当するデータが複数ある場合' do
      before do
        create(:card, project: project, column: column,
                      due_date: Date.today, name: '該当する1')
        create(:card, project: project, column: column,
                      due_date: Date.today - 3.days, name: '該当する2')
        create(:card, project: project, column: column,
                      due_date: Date.today + 3.days, name: '該当しない')
      end

      it '結果が正しいこと' do
        expect { Log.create_due_date_notification_logs! }
          .to change { Log.count }.by(2)
      end
    end
  end
end
