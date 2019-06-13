require 'rails_helper'

RSpec.describe CardDecorator, type: :decorator do
  describe '#due_date_text' do
    subject { card.due_date_text }

    before do
      decorate(card)
    end

    context '期日がある場合' do
      let(:card) { create(:card, due_date: '2019-01-01') }

      it '内容が正しいこと' do
        is_expected.to eq '期限:2019/01/01'
      end
    end

    context '期日がない場合' do
      let(:card) { create(:card, due_date: nil) }

      it '内容が正しいこと' do
        is_expected.to eq '期限: 設定なし'
      end
    end
  end
end
