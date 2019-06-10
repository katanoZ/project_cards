require 'rails_helper'

RSpec.describe FlashHelper, type: :helper do
  describe '#flash_class' do
    subject { flash_class(key) }

    context 'キーがnoticeの場合' do
      let(:key) { 'notice' }

      it '内容が正しいこと' do
        is_expected.to eq 'alert alert-primary alert-dismissible fade show'
      end
    end

    context 'キーがalertの場合' do
      let(:key) { 'alert' }

      it '内容が正しいこと' do
        is_expected.to eq 'alert alert-danger alert-dismissible fade show'
      end
    end
  end
end
