require 'rails_helper'

RSpec.describe FormHelper, type: :helper do
  describe '#field_class' do
    subject { field_class(model: model, field: field) }

    let(:model) { double('test_model') }
    let(:field) { :test_field }
    before do
      allow(model).to receive(:errors).and_return(messages)
    end

    context '項目にエラーがある場合' do
      let(:messages) { { test_field: ['error'] } }

      it '内容が正しいこと' do
        is_expected.to eq 'form-control form-control-lg is-invalid'
      end
    end

    context '項目にエラーがない場合' do
      let(:messages) { { test_field: [] } }

      it '内容が正しいこと' do
        is_expected.to eq 'form-control form-control-lg'
      end
    end
  end
end
