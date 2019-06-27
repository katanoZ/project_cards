require 'rails_helper'

RSpec.describe ParticipationCreateLogsCallbacks, type: :callback do
  let(:project) { create(:project) }
  let(:user) { create(:user, name: '佐藤花子') }

  describe '#after_create' do
    it '結果が正しいこと' do
      expect { user.participate_in(project) }
        .to change { Log.where('content LIKE(?)', '%参加%').count }.by(1)
    end
  end

  describe '#content' do
    it '内容が正しいこと' do
      user.participate_in(project)
      log = Log.where('content LIKE(?)', '%参加%').last
      expect(log.content).to eq '佐藤花子さんがこのプロジェクトに参加しました'
      expect(log.project).to eq project
    end
  end
end
