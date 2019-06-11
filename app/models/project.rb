class Project < ApplicationRecord
  has_many :columns, -> { order(position: :asc) }, dependent: :destroy
  belongs_to :owner, class_name: 'User', foreign_key: :user_id

  # プロジェクト一覧で1ページに表示するプロジェクトの個数
  COUNT_PER_PAGE = 9

  # プロジェクト一覧の先頭に挿入されるプロジェクト以外（リンクなど）の個数
  PADDING_COUNT = 1

  validates :name, presence: true, uniqueness: true, length: { maximum: 140 }
  validates :summary, length: { maximum: 300 }

  scope :for_full_list, ->(page) do
    order(id: :desc).page(page).per(COUNT_PER_PAGE)
  end

  scope :for_myprojects_list, ->(user, page) do
    if page
      for_myprojects_second_page_or_later(user, page)
    else
      for_myprojects_first_page(user)
    end
  end

  scope :for_myprojects_first_page, ->(user) do
    count_for_first_page = COUNT_PER_PAGE - PADDING_COUNT
    where(owner: user).order(id: :desc).page(nil).per(count_for_first_page)
  end

  scope :for_myprojects_second_page_or_later, ->(user, page) do
    # もし1ページ目が指定されても値を返さないようにする
    # （kaminariのissueによると、1ページ目でpaddingマイナス値を使うと不具合がある）
    return [] if ['1', 1, nil].include?(page)

    where(owner: user).order(id: :desc).page(page).per(COUNT_PER_PAGE)
                      .padding(-PADDING_COUNT)
  end

  scope :accessible, ->(user) do
    # TODO: 招待機能を作成する際に、招待されたユーザもアクセス可能に設定すること
    where(owner: user)
  end

  def accessible?(user)
    self.class.accessible(user).exists?(id)
  end

  def myproject?(user)
    owner == user
  end
end
