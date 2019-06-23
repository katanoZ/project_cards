require 'rails_helper'

RSpec.describe Project, type: :model do
  describe '.for_full_list' do
    context '該当のデータが存在する場合' do
      let(:results) { Project.for_full_list(2) }

      before do
        (1..12).each { |n| create(:project, name: "Project_#{n}") }
      end

      it '件数が正しいこと' do
        # 全12件で1ページ9件なので、2ページ目は3件
        expect(results.count).to eq 3
      end

      it '内容が正しいこと' do
        # 1ページ目[12, 11, 10, 9, 8, 7, 6, 5, 4]、2ページ目[3, 2, 1]
        expect(results.first.name).to eq 'Project_3'
      end
    end

    context '該当のデータが存在しない場合' do
      let(:results) { Project.for_full_list(1) }

      it '件数が正しいこと' do
        expect(results.count).to eq 0
      end
    end
  end

  describe '.for_accessible_list' do
    let(:user) { create(:user) }

    before do
      allow(Project).to receive(:for_accessible_list_first_page)
      allow(Project).to receive(:for_accessible_list_second_page_or_later)
    end

    context '1ページ目の場合' do
      it '.for_accessible_list_first_pageを呼び出すこと' do
        Project.for_accessible_list(user, nil)
        expect(Project).to have_received(:for_accessible_list_first_page).once
        expect(Project).not_to have_received(:for_accessible_list_second_page_or_later)
      end
    end

    context '2ページ目以降の場合' do
      it '.for_accessible_list_second_page_or_laterを呼び出すこと' do
        Project.for_accessible_list(user, 2)
        expect(Project).to have_received(:for_accessible_list_second_page_or_later).once
        expect(Project).not_to have_received(:for_accessible_list_first_page)
      end
    end
  end

  describe '.for_accessible_list_first_page' do
    let(:user) { create(:user) }
    let(:results) { Project.for_accessible_list_first_page(user) }

    context '該当のデータが存在する場合' do
      before do
        (1..3).each { |n| create(:project, name: "Project_#{n}", owner: user) }
      end

      it '件数が正しいこと' do
        expect(results.count).to eq 3
      end

      it '内容が正しいこと' do
        expect(results.first.name).to eq 'Project_3'
      end
    end

    context '該当のデータが存在しない場合' do
      before { create(:project) }

      it '件数が正しいこと' do
        expect(results.count).to eq 0
      end
    end
  end

  describe '.for_accessible_list_second_page_or_later' do
    let(:user) { create(:user) }

    context '該当のデータが存在する場合' do
      let(:results) { Project.for_accessible_list_second_page_or_later(user, 2) }

      before do
        (1..12).each { |n| create(:project, name: "Project_#{n}", owner: user) }
      end

      it '件数が正しいこと' do
        # 該当が全12件、1ページあたり9件だがpaddingが-1なので、1ページ目8件で2ページ目は4件
        expect(results.count).to eq 4
      end

      it '内容が正しいこと' do
        # 1ページ目[12, 11, 10, 9, 8, 7, 6, 5]、2ページ目[4, 3, 2, 1]
        expect(results.first.name).to eq 'Project_4'
      end
    end

    context '該当のデータが存在しない場合' do
      let(:results) { Project.for_accessible_list_second_page_or_later(user, 2) }

      before { create_list(:project, 12) }

      it '件数が正しいこと' do
        expect(results.count).to eq 0
      end
    end

    context '1ページ目が指定された場合' do
      before { create_list(:project, 12, owner: user) }

      context 'pageがnilの場合' do
        let(:results) { Project.for_accessible_list_second_page_or_later(user, nil) }

        it '件数が正しいこと' do
          expect(results.count).to eq 0
        end

        it '内容が正しいこと' do
          expect(results).to eq []
        end
      end

      context "pageが'1'（文字）の場合" do
        let(:results) { Project.for_accessible_list_second_page_or_later(user, '1') }

        it '件数が正しいこと' do
          expect(results.count).to eq 0
        end

        it '内容が正しいこと' do
          expect(results).to eq []
        end
      end

      context 'pageが1（数値）の場合' do
        let(:results) { Project.for_accessible_list_second_page_or_later(user, 1) }

        it '件数が正しいこと' do
          expect(results.count).to eq 0
        end

        it '内容が正しいこと' do
          expect(results).to eq []
        end
      end
    end
  end

  describe '.accessible' do
    let(:results) { Project.accessible(user) }
    let(:user) { create(:user) }

    context '該当のデータが存在する場合' do
      context 'ユーザがプロジェクトのオーナーの場合' do
        before { create(:project, owner: user) }

        it '件数が正しいこと' do
          expect(results.count).to eq 1
        end

        it '内容が正しいこと' do
          expect(user.owner?(results.first)).to be_truthy
        end
      end

      context 'ユーザがプロジェクトのメンバーの場合' do
        before do
          project = create(:project)
          user.participate_in(project)
        end

        it '件数が正しいこと' do
          expect(results.count).to eq 1
        end

        it '内容が正しいこと' do
          expect(user.member?(results.first)).to be_truthy
        end
      end
    end

    context '該当のデータが存在しない場合' do
      before do
        # 無関係のプロジェクト
        create(:project)
        # 招待プロジェクト
        create(:invitation, user: user)
      end

      it '件数が正しいこと' do
        expect(results.count).to eq 0
      end
    end
  end

  describe '.owned_by' do
    let(:results) { Project.owned_by(user) }
    let(:user) { create(:user) }

    context '該当のデータが存在する場合' do
      before { create(:project, owner: user) }

      it '件数が正しいこと' do
        expect(results.count).to eq 1
      end

      it '内容が正しいこと' do
        expect(user.owner?(results.first)).to be_truthy
      end
    end

    context '該当のデータが存在しない場合' do
      before do
        # 無関係のプロジェクト
        create(:project)
        # 招待プロジェクト
        create(:invitation, user: user)
        # 参加プロジェクト
        create(:participation, user: user)
      end

      it '件数が正しいこと' do
        expect(results.count).to eq 0
      end
    end
  end

  describe '.participated_in_by' do
    let(:results) { Project.participated_in_by(user) }
    let(:user) { create(:user) }

    context '該当のデータが存在する場合' do
      before do
        project = create(:project)
        user.participate_in(project)
      end

      it '件数が正しいこと' do
        expect(results.count).to eq 1
      end

      it '内容が正しいこと' do
        expect(user.member?(results.first)).to be_truthy
      end
    end

    context '該当のデータが存在しない場合' do
      before do
        # 無関係のプロジェクト
        create(:project)
        # 招待プロジェクト
        create(:invitation, user: user)
        # オーナーのプロジェクト
        create(:project, owner: user)
      end

      it '件数が正しいこと' do
        expect(results.count).to eq 0
      end
    end
  end

  describe '#invite' do
    let(:user) { create(:user) }
    let(:project) { create(:project) }

    it '結果が正しいこと' do
      expect(project.invite(user)).to be_truthy
    end

    it '内容が正しいこと' do
      expect { project.invite(user) }
        .to change { project.invitations.count }.from(0).to(1)
      expect(project.invitations.first.user).to eq user
    end
  end
end
