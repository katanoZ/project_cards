require 'rails_helper'

RSpec.describe ProjectDecorator, type: :decorator do
  describe 'form_path' do
    subject { project.form_path }

    before do
      decorate(project)
    end

    context '新規作成の場合' do
      let(:project) { build(:project) }

      it '内容が正しいこと' do
        is_expected.to eq '/myprojects'
      end
    end

    context '編集の場合' do
      let(:project) { create(:project) }

      it '内容が正しいこと' do
        is_expected.to match %r{\A/myprojects/\d+\z}
      end
    end
  end
end
