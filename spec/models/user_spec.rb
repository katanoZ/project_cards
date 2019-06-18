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

  describe '.search' do
    before do
      create(:user, name: '田中花子')
    end

    context '該当のユーザが存在する場合' do
      let!(:user) { create(:user, name: '田中花太郎') }
      let(:results) { User.search('太') }

      it '件数が正しいこと' do
        expect(results.count).to eq 1
      end

      it '内容が正しいこと' do
        expect(results.first).to eq user
      end
    end

    context '該当のユーザが存在しない場合' do
      let(:results) { User.search('佐藤') }

      it '件数が正しいこと' do
        expect(results.count).to eq 0
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

  describe '#attach_new_image' do
    let(:user) { create(:user) }

    context 'new_imageが存在する場合' do
      let(:new_image) { fixture_file_upload('sample.png', 'image/png') }

      after do
        user.image.purge
      end

      it '結果が正しいこと' do
        user.update!(new_image: new_image)
        expect(user.image.attached?).to be_truthy
      end

      it '内容が正しいこと' do
        user.update!(new_image: new_image)
        expect(user.image.filename).to eq 'sample.png'
        expect(user.image.content_type).to eq 'image/png'
      end
    end

    context 'new_imageが存在しない場合' do
      let(:new_image) { nil }

      it '結果が正しいこと' do
        user.update!(new_image: new_image)
        expect(user.image.attached?).to be_falsey
      end
    end
  end

  describe 'owner?' do
    subject { user.owner?(project) }
    let(:user) { create(:user) }

    context 'ユーザがプロジェクトのオーナーの場合' do
      let(:project) { create(:project, owner: user) }

      it '結果が正しいこと' do
        is_expected.to be_truthy
      end
    end

    context 'ユーザがプロジェクトのオーナーでない場合' do
      let(:project) { create(:project) }

      it '結果が正しいこと' do
        is_expected.to be_falsey
      end
    end
  end

  # include RemoteFileAttachable
  it_behaves_like 'remote_file_attachable'
end
