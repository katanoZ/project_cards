require 'rails_helper'

RSpec.describe InvitationCreateLogsCallbacks, type: :callback do
  let!(:owner) { create(:user, name: '山田太郎') }
  let!(:user) { create(:user, name: '佐藤花子') }
  let!(:project) { create(:project, owner: owner) }

  describe '#after_create' do
    it 'ログが1件作成されること' do
      expect { project.invite(user) }.to change { Log.count }.by(1)
    end

    it 'ログの内容が正しいこと' do
      project.invite(user)
      log = Log.order(:created_at).last
      expect(log.content)
        .to eq '山田太郎さんが佐藤花子さんをこのプロジェクトに招待しました'
      expect(log.project).to eq project
    end
  end
end
