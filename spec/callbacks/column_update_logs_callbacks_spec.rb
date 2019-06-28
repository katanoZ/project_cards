require 'rails_helper'

RSpec.describe ColumnUpdateLogsCallbacks, type: :callback do
  let(:user) { create(:user, name: '山田太郎') }
  let(:project) { create(:project, owner: user) }
  let(:column) { create(:column, name: 'テスト', project: project) }

  describe '#after_update' do
    it '結果が正しいこと' do
      expect { column.update(name: 'アップデート') }
        .to change { Log.where('content LIKE(?)', '%カラムの名前%編集%').count }
        .by(1)
    end
  end

  describe '#content' do
    context '操作者が設定されている場合' do
      before { column.operator = user }

      it '内容が正しいこと' do
        column.update(name: 'アップデート')
        log = Log.where('content LIKE(?)', '%カラムの名前%編集%').last
        expect(log.content).to eq '山田太郎さんがテストカラムの名前をアップデートに編集しました'
        expect(log.project).to eq project
      end
    end

    context '操作者が設定されていない場合' do
      it '内容が正しいこと' do
        column.update(name: 'アップデート')
        log = Log.where('content LIKE(?)', '%カラムの名前%編集%').last
        expect(log.content).to eq 'テストカラムの名前がアップデートに編集されました'
        expect(log.project).to eq project
      end
    end
  end
end
