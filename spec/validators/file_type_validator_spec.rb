require 'rails_helper'

describe FileTypeValidator, type: :validator do
  let(:model_class) do
    Struct.new(:file) do
      include ActiveModel::Validations
      validates :file, file_type: { in: %w[image/jpeg image/gif image/png] }
    end
  end

  describe '#validate_each' do
    let(:model) { model_class.new(file) }

    context 'ファイルタイプが指定された範囲に含まれる場合' do
      let(:file) { fixture_file_upload('sample.png', 'image/png') }

      it '結果が正しいこと' do
        expect(model).to be_valid
      end
    end

    context 'ファイルタイプが指定された範囲に含まれない場合' do
      let(:file) { fixture_file_upload('sample.pdf', 'application/pdf') }

      it '結果が正しいこと' do
        expect(model).to be_invalid
      end

      it 'エラーメッセージが正しいこと' do
        model.validate
        expect(model.errors[:file]).to eq ['はJPEG, GIF, PNG形式のファイルを指定してください']
      end
    end
  end
end
