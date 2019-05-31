require 'rails_helper'

shared_examples_for 'remote_file_attachable' do
  describe '#attach_remote_file!' do
    let(:model) { build(described_class.to_s.underscore.to_sym) }
    let(:url) { 'http://example.com/sample.png' }
    let(:file) { fixture_file_upload('sample.png', 'image/png') }

    before do
      allow(OpenURI).to receive(:open_uri).and_yield(file)
    end

    after do
      model.attachment_target.purge
    end

    it '結果が正しいこと' do
      model.attach_remote_file!(url)
      expect(model.attachment_target.attached?).to be_truthy
    end

    it '内容が正しいこと' do
      model.attach_remote_file!(url)
      expect(model.attachment_target.filename).to eq 'sample.png'
      expect(model.attachment_target.content_type).to eq 'image/png'
    end
  end
end
