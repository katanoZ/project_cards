require 'rails_helper'

describe OwnerRejectionValidator, type: :validator do
  let(:model_class) do
    Struct.new(:user, :project) do
      include ActiveModel::Validations
      validates :user, owner_rejection: true
    end
  end

  describe '#validate_each' do
    let(:model) { model_class.new(user, project) }
    let(:user) { create(:user) }

    context 'ユーザがプロジェクトのオーナーでない場合' do
      let(:project) { create(:project) }

      it '結果が正しいこと' do
        expect(model).to be_valid
      end
    end

    context 'ユーザがプロジェクトのオーナーの場合' do
      let(:project) { create(:project, owner: user) }

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
