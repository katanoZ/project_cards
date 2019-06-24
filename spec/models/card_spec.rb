require 'rails_helper'

RSpec.describe Card, type: :model do
  describe '#move_to_higher_column' do
    let(:project) { create(:project) }

    context '最後のカラムの中にあるカードの場合' do
      let(:columns) { create_list(:column, 3, project: project) }
      let(:card) { create(:card, project: project, column: columns.last) }

      before do
        create_list(:card, 3, project: project, column: columns.last.higher_item)
      end

      it '結果が正しいこと' do
        expect(card.move_to_higher_column).to be_truthy
      end

      it '内容が正しいこと' do
        card.move_to_higher_column
        # カードはposition順に下から並ぶので、card.lastが一番上に表示される
        expect(card.last?).to be_truthy
        expect(card.column).to eq columns.last.higher_item
      end
    end

    context '最初のカラムの中にあるカードの場合' do
      let(:columns) { create_list(:column, 3, project: project) }
      let(:card) { create(:card, project: project, column: columns.first) }

      it '結果が正しいこと' do
        expect(card.move_to_higher_column).to be_falsy
      end
    end

    context '1つだけのカラムの中にあるカードの場合' do
      let(:column) { create(:column, project: project) }
      let(:card) { create(:card, project: project, column: column) }

      it '結果が正しいこと' do
        expect(card.move_to_higher_column).to be_falsy
      end
    end
  end

  describe '#move_to_lower_column' do
    let(:project) { create(:project) }

    context '最初のカラムの中にあるカードの場合' do
      let(:columns) { create_list(:column, 3, project: project) }
      let(:card) { create(:card, project: project, column: columns.first) }

      before do
        create_list(:card, 3, project: project, column: columns.first.lower_item)
      end

      it '結果が正しいこと' do
        expect(card.move_to_lower_column).to be_truthy
      end

      it '内容が正しいこと' do
        card.move_to_lower_column
        # カードはposition順に下から並ぶので、card.lastが一番上に表示される
        expect(card.last?).to be_truthy
        expect(card.column).to eq columns.first.lower_item
      end
    end

    context '最後のカラムの中にあるカードの場合' do
      let(:columns) { create_list(:column, 3, project: project) }
      let(:card) { create(:card, project: project, column: columns.last) }

      it '結果が正しいこと' do
        expect(card.move_to_lower_column).to be_falsy
      end
    end

    context '1つだけのカラムの中にあるカードの場合' do
      let(:column) { create(:column, project: project) }
      let(:card) { create(:card, project: project, column: column) }

      it '結果が正しいこと' do
        expect(card.move_to_lower_column).to be_falsy
      end
    end
  end

  describe '#verify_assignee' do
    let(:column) { create(:column) }
    let(:project) { column.project }

    context '担当者に指定できる場合' do
      context 'プロジェクトのオーナーを担当者にする場合' do
        let(:owner) { project.owner }
        let(:card) { build(:card, project: project, column: column, assignee: owner) }

        it '結果が正しいこと' do
          expect(card).to be_valid
        end
      end

      context 'プロジェクトのメンバーを担当者にする場合' do
        let(:user) { create(:user) }
        let(:card) { build(:card, project: project, column: column, assignee: user) }
        before { user.participate_in(project) }

        it '結果が正しいこと' do
          expect(card).to be_valid
        end
      end
    end

    context '担当者に指定できない場合' do
      let(:user) { create(:user) }

      context 'プロジェクトの招待者を担当者にする場合' do
        let(:card) { build(:card, project: project, column: column, assignee: user) }
        before { project.invite(user) }

        it '結果が正しいこと' do
          expect(card).to be_invalid
        end

        it 'エラーメッセージが正しいこと' do
          card.validate
          expect(card.errors[:assignee]).to eq ['は不正な値です']
        end
      end

      context 'プロジェクトと無関係のユーザを担当者にする場合' do
        let(:card) { build(:card, project: project, column: column, assignee: user) }

        it '結果が正しいこと' do
          expect(card).to be_invalid
        end

        it 'エラーメッセージが正しいこと' do
          card.validate
          expect(card.errors[:assignee]).to eq ['は不正な値です']
        end
      end
    end
  end
end
