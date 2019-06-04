require 'rails_helper'

describe FileSizeValidator, type: :validator do
  let(:model_class) do
    Struct.new(:file) do
      include ActiveModel::Validations
      validates :file, file_size: { maximum: 1.kilobytes }
    end
  end

  describe '#validate_each' do
    let(:model) { model_class.new(file) }

    context 'ファイルサイズが最大値以下の場合' do
      # sample.pngは407byte
      let(:file) { fixture_file_upload('sample.png', 'image/png') }

      it '結果が正しいこと' do
        expect(model).to be_valid
      end
    end

    context 'ファイルサイズが最大値以上の場合' do
      # sample.pdfは6kbyte
      let(:file) { fixture_file_upload('sample.pdf', 'application/pdf') }

      it '結果が正しいこと' do
        expect(model).to be_invalid
      end

      it 'エラーメッセージが正しいこと' do
        model.validate
        expect(model.errors[:file]).to eq ['のファイルサイズは1KB以下にしてください']
      end
    end
  end
end
