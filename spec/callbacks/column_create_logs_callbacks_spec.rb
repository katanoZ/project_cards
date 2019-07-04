require 'rails_helper'

RSpec.describe ColumnCreateLogsCallbacks, type: :callback do
  let!(:user) { create(:user, name: '山田太郎') }
  let!(:project) { create(:project, owner: user) }
  let(:column) { build(:column, name: 'テスト', project: project) }

  describe '#after_create' do
    context '操作者が設定されている場合' do
      before { column.operator = user }

      it 'ログが1件作成されること' do
        expect { column.run_callbacks(:create) }.to change { Log.count }.by(1)
      end

      it 'ログの内容が正しいこと' do
        column.run_callbacks(:create)
        log = Log.order(:created_at).last
        expect(log.content).to eq '山田太郎さんがテストカラムを作成しました'
        expect(log.project).to eq project
      end
    end

    context '操作者が設定されていない場合' do
      it 'ログが1件作成されること' do
        expect { column.run_callbacks(:create) }.to change { Log.count }.by(1)
      end

      it 'ログの内容が正しいこと' do
        column.run_callbacks(:create)
        log = Log.order(:created_at).last
        expect(log.content).to eq 'テストカラムが作成されました'
        expect(log.project).to eq project
      end
    end
  end
end
