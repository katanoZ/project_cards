require 'rails_helper'

RSpec.describe ColumnUpdateLogsCallbacks, type: :callback do
  let!(:user) { create(:user, name: '山田太郎') }
  let!(:project) { create(:project, owner: user) }
  let!(:column) { create(:column, name: 'テスト', project: project) }

  describe '#after_update' do
    context '操作者が設定されている場合' do
      before { column.operator = user }

      it 'ログが1件作成されること' do
        expect { column.update(name: 'アップデート') }
          .to change { Log.count }.by(1)
      end

      it 'ログの内容が正しいこと' do
        column.update(name: 'アップデート')
        log = Log.order(:created_at).last
        expect(log.content)
          .to eq '山田太郎さんがテストカラムの名前をアップデートに編集しました'
        expect(log.project).to eq project
      end
    end

    context '操作者が設定されていない場合' do
      it 'ログが1件作成されること' do
        expect { column.update(name: 'アップデート') }
          .to change { Log.count }.by(1)
      end

      it 'ログの内容が正しいこと' do
        column.update(name: 'アップデート')
        log = Log.order(:created_at).last
        expect(log.content).to eq 'テストカラムの名前がアップデートに編集されました'
        expect(log.project).to eq project
      end
    end
  end
end
