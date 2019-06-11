require 'rails_helper'

RSpec.describe ColumnDecorator, type: :decorator do
  describe '#arrow_link_class' do
    let(:project) { create(:project) }
    let(:columns) { create_list(:column, 3, project: project) }

    before do
      decorate(column)
    end

    context 'カラムがリストの左端の場合' do
      let(:column) { columns.first }

      context '左へ行く矢印の場合' do
        it '内容が正しいこと' do
          expect(column.arrow_link_class(:left))
            .to eq 'text-middle-purple hover-middle-purple invisible'
        end
      end

      context '右へ行く矢印の場合' do
        it '内容が正しいこと' do
          expect(column.arrow_link_class(:right))
            .to eq 'text-middle-purple hover-middle-purple'
        end
      end
    end

    context 'カラムがリストの右端の場合' do
      let(:column) { columns.last }

      context '左へ行く矢印の場合' do
        it '内容が正しいこと' do
          expect(column.arrow_link_class(:left))
            .to eq 'text-middle-purple hover-middle-purple'
        end
      end

      context '右へ行く矢印の場合' do
        it '内容が正しいこと' do
          expect(column.arrow_link_class(:right))
            .to eq 'text-middle-purple hover-middle-purple invisible'
        end
      end
    end
  end
end
