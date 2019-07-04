require 'rails_helper'

RSpec.describe CardUpdateLogsCallbacks, type: :callback do
  let!(:user) { create(:user, name: '山田太郎') }
  let!(:project) { create(:project, owner: user) }
  let!(:column) { create(:column, project: project) }
  let!(:card) { create(:card, name: 'テスト', project: project, column: column) }

  describe '#after_update' do
    context '操作者が設定されている場合' do
      before { card.operator = user }

      it 'ログが1件作成されること' do
        expect { card.update(name: 'アップデート') }.to change { Log.count }.by(1)
      end

      it 'ログの内容が正しいこと' do
        card.update(name: 'アップデート')
        log = Log.order(:created_at).last
        expect(log.content)
          .to eq '山田太郎さんがテストカードの名前をアップデートに編集しました'
        expect(log.project).to eq project
      end
    end

    context '操作者が設定されていない場合' do
      it 'ログが1件作成されること' do
        expect { card.update(name: 'アップデート') }.to change { Log.count }.by(1)
      end

      it 'ログの内容が正しいこと' do
        card.update(name: 'アップデート')
        log = Log.order(:created_at).last
        expect(log.content).to eq 'テストカードの名前がアップデートに編集されました'
        expect(log.project).to eq project
      end
    end
  end
end
