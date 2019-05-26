require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe '#auth_path' do
    subject { auth_path(provider) }

    context 'googleが選択された場合' do
      let(:provider) { :google_oauth2 }
      it '内容が正しいこと' do
        is_expected.to eq '/auth/google_oauth2'
      end
    end

    context 'twitterが選択された場合' do
      let(:provider) { :twitter }
      it '内容が正しいこと' do
        is_expected.to eq '/auth/twitter'
      end
    end

    context 'githubが選択された場合' do
      let(:provider) { :github }
      it '内容が正しいこと' do
        is_expected.to eq '/auth/github'
      end
    end
  end
end
