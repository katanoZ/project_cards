require 'rails_helper'

RSpec.describe ParticipationCreateLogsCallbacks, type: :callback do
  let!(:project) { create(:project) }
  let!(:user) { create(:user, name: '佐藤花子') }

  describe '#after_create' do
    it 'ログが1件作成されること' do
      expect { user.participate_in(project) }.to change { Log.count }.by(1)
    end

    it 'ログの内容が正しいこと' do
      user.participate_in(project)
      log = Log.order(:created_at).last
      expect(log.content).to eq '佐藤花子さんがこのプロジェクトに参加しました'
      expect(log.project).to eq project
    end
  end
end
