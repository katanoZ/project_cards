require 'rails_helper'

shared_examples_for 'remote_image_attachable' do
  describe '#attach_remote_image!' do
    let(:model) { build(described_class.to_s.underscore.to_sym) }
    let(:url) { 'http://example.com/sample.png' }

    before do
      # 添付する画像ファイルのモックを作成
      @file = StringIO.new('')
      @file.define_singleton_method(:content_type) { 'image/png' }
      allow(OpenURI).to receive(:open_uri).and_yield(@file)
    end

    after do
      @file.close
      model.image.purge
    end

    it '結果が正しいこと' do
      model.attach_remote_image!(url)
      expect(model.image.attached?).to be_truthy
    end

    it '内容が正しいこと' do
      model.attach_remote_image!(url)
      expect(model.image.filename).to eq 'sample.png'
      expect(model.image.content_type).to eq 'image/png'
    end
  end
end
