require 'rails_helper'

RSpec.describe UserDecorator, type: :decorator do
  describe '#filefield_label_class' do
    subject { user.filefield_label_class }
    let(:user) { create(:user) }

    before do
      allow(user).to receive(:errors).and_return(messages)
      decorate(user)
    end

    context '画像ファイル項目にエラーがある場合' do
      let(:messages) { { new_image: ['error'] } }

      it '内容が正しいこと' do
        is_expected.to eq 'btn btn-lg btn-block btn-secondary bg-light-purple border-danger text-middle-purple mt-2 mt-lg-4'
      end
    end

    context '画像ファイル項目にエラーがない場合' do
      let(:messages) { { new_image: [] } }

      it '内容が正しいこと' do
        is_expected.to eq 'btn btn-lg btn-block btn-secondary bg-light-purple border-middle-purple text-middle-purple mt-2 mt-lg-4'
      end
    end
  end
end
