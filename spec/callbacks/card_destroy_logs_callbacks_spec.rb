require 'rails_helper'

RSpec.describe CardDestroyLogsCallbacks, type: :callback do
  let(:user) { create(:user, name: '山田太郎') }
  let(:project) { create(:project, owner: user) }
  let(:column) { create(:column, name: 'サンプル', project: project) }
  let(:card) { create(:card, name: 'テスト', project: project, column: column) }

  describe '#after_destroy' do
    it '結果が正しいこと' do
      expect { card.destroy }
        .to change { Log.where('content LIKE(?)', '%カード%削除%').count }.by(1)
    end
  end

  describe '#content' do
    context '操作者が設定されている場合' do
      before { card.operator = user }

      it '内容が正しいこと' do
        card.destroy
        log = Log.where('content LIKE(?)', '%カード%削除%').last
        expect(log.content).to eq '山田太郎さんがテストカードを削除しました'
        expect(log.project).to eq project
      end
    end

    context '操作者が設定されていない場合' do
      it '内容が正しいこと' do
        card.destroy
        log = Log.where('content LIKE(?)', '%カード%削除%').last
        expect(log.content).to eq 'サンプルカラムのテストカードが削除されました'
        expect(log.project).to eq project
      end
    end
  end
end
