require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.find_or_create_from_auth' do
    let(:result) { User.find_or_create_from_auth(auth) }
    let(:auth) do
      { provider: user.provider, uid: user.uid, info: { name: user.name } }
    end

    context 'ユーザが存在しない場合' do
      let(:user) { build(:user) }

      before do
        # #attach_remote_image!を呼び出す
        expect_any_instance_of(User).to receive(:attach_remote_image!).once
      end

      it '結果が正しいこと' do
        expect { result }.to change { User.count }.from(0).to(1)
      end

      it '内容が正しいこと' do
        expect(result).to have_attributes(provider: user.provider, uid: user.uid)
      end
    end

    context 'ユーザが存在する場合' do
      let!(:user) { create(:user) }

      before do
        # #attach_remote_image!を呼び出さない
        expect_any_instance_of(User).not_to receive(:attach_remote_image!)
      end

      it '結果が正しいこと' do
        expect { result }.not_to change { User.count }
      end

      it '内容が正しいこと' do
        expect(result).to eq User.first
      end
    end
  end

  describe '#login_message' do
    let(:login_user) do
      User.find_or_create_by(provider: user.provider, uid: user.uid) do |u|
        u.name = user.name
      end
    end
    subject { login_user.login_message }

    context '新規ユーザの場合' do
      let(:user) { build(:user) }

      it '内容が正しいこと' do
        is_expected.to eq 'アカウント登録しました'
      end
    end

    context '既存ユーザの場合' do
      let!(:user) { create(:user) }

      it '内容が正しいこと' do
        is_expected.to eq 'ログインしました'
      end
    end
  end

  # include RemoteImageAttachable
  it_behaves_like 'remote_image_attachable'
end
