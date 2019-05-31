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
        # #attach_remote_file!を呼び出す
        expect_any_instance_of(User).to receive(:attach_remote_file!).once
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
        # #attach_remote_file!を呼び出さない
        expect_any_instance_of(User).not_to receive(:attach_remote_file!)
      end

      it '結果が正しいこと' do
        expect { result }.not_to change { User.count }
      end

      it '内容が正しいこと' do
        expect(result).to eq User.first
      end
    end
  end

  describe '#set_find_message' do
    let(:user) { create(:user) }
    let(:login_user) { User.find(user.id) }

    it '内容が正しいこと' do
      expect(login_user.login_message).to eq 'ログインしました'
    end
  end

  describe '#set_create_message' do
    let(:login_user) { create(:user) }

    it '内容が正しいこと' do
      expect(login_user.login_message).to eq 'アカウント登録しました'
    end
  end

  # include RemoteFileAttachable
  it_behaves_like 'remote_file_attachable'
end
