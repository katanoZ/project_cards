require 'rails_helper'

RSpec.describe Participation, type: :model do
  describe '#destroy_invitation!' do
    let(:user) { create(:user) }
    let(:project) { create(:project) }

    context 'ユーザがプロジェクトに招待されている場合' do
      before { Invitation.create(user: user, project: project) }

      it 'プロジェクトに参加すると招待が削除されること' do
        expect { Participation.create(user: user, project: project) }
          .to change { Invitation.count }.from(1).to(0)
      end
    end

    context 'ユーザがプロジェクトに招待されていない場合' do
      it 'プロジェクトに参加してもエラーが起きないこと' do
        # プロジェクト参加方法を限定しないため、招待されていないプロジェクトに参加しても、
        # モデルではエラーにしない。
        # なお、アプリケーションのお知らせ画面からのプロジェクト参加では、
        # ParticipationsControllerで招待済みのプロジェクトのみ処理対象にするため、
        # 招待されていないプロジェクトに参加しようとすると404エラーになる。
        expect { Participation.create(user: user, project: project) }
          .not_to raise_error
      end
    end
  end
end
