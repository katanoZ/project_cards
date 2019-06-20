require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe '#verify_owner' do
    let(:project) { create(:project) }

    context 'ユーザがプロジェクトのオーナーではない場合' do
      let(:user) { create(:user) }
      let(:invitation) { build(:invitation, project: project, user: user) }

      it '結果が正しいこと' do
        expect(invitation).to be_valid
      end
    end

    context 'ユーザがプロジェクトのオーナーの場合' do
      let(:invitation) { build(:invitation, project: project, user: project.owner) }

      it '結果が正しいこと' do
        expect(invitation).to be_invalid
      end

      it 'エラーメッセージが正しいこと' do
        invitation.validate
        expect(invitation.errors[:user]).to eq ['は不正な値です']
      end
    end
  end
end
