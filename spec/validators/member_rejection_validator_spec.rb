require 'rails_helper'

describe MemberRejectionValidator, type: :validator do
  let(:model_class) do
    Struct.new(:user, :project) do
      include ActiveModel::Validations
      validates :user, member_rejection: true
    end
  end

  describe '#validate_each' do
    let(:model) { model_class.new(user, project) }
    let(:user) { create(:user) }
    let(:project) { create(:project) }

    context 'ユーザがプロジェクトのメンバーでない場合' do
      it '結果が正しいこと' do
        expect(model).to be_valid
      end
    end

    context 'ユーザがプロジェクトのメンバーの場合' do
      before do
        user.participate_in(project)
      end

      it '結果が正しいこと' do
        expect(model).to be_invalid
      end

      it 'エラーメッセージが正しいこと' do
        model.validate
        expect(model.errors[:user]).to eq ['は不正な値です']
      end
    end
  end
end
