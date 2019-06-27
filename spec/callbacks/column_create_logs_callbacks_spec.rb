require 'rails_helper'

RSpec.describe ColumnCreateLogsCallbacks, type: :callback do
  let(:user) { create(:user, name: '山田太郎') }
  let(:project) { create(:project, owner: user) }
  let(:column) { build(:column, name: 'テスト', project: project) }

  describe '#after_create' do
    it '結果が正しいこと' do
      expect { column.save }
        .to change { Log.where('content LIKE(?)', '%カラム%作成%').count }.by(1)
    end
  end

  describe '#content' do
    context '操作者が設定されている場合' do
      before { column.operator = user }

      it '内容が正しいこと' do
        column.save
        log = Log.where('content LIKE(?)', '%カラム%作成%').last
        expect(log.content).to eq '山田太郎さんがテストカラムを作成しました'
        expect(log.project).to eq project
      end
    end

    context '操作者が設定されていない場合' do
      it '内容が正しいこと' do
        column.save
        log = Log.where('content LIKE(?)', '%カラム%作成%').last
        expect(log.content).to eq 'テストカラムが作成されました'
        expect(log.project).to eq project
      end
    end
  end
end
