class Project < ApplicationRecord
  has_many :columns, -> { order(position: :asc) }, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :invited_users, through: :invitations, source: :user
  has_many :participations, dependent: :destroy
  has_many :members, through: :participations, source: :user
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id

  # プロジェクト一覧で1ページに表示するプロジェクトの個数
  COUNT_PER_PAGE = 9

  # プロジェクト一覧の先頭に挿入されるプロジェクト以外（リンクなど）の個数
  PADDING_COUNT = 1

  validates :name, presence: true, uniqueness: true, length: { maximum: 140 }
  validates :summary, length: { maximum: 300 }

  scope :for_full_list, ->(page) do
    order(id: :desc).page(page).per(COUNT_PER_PAGE)
  end

  scope :for_accessible_list, ->(user, page) do
    if page
      for_accessible_list_second_page_or_later(user, page)
    else
      for_accessible_list_first_page(user)
    end
  end

  scope :for_accessible_list_first_page, ->(user) do
    count_for_first_page = COUNT_PER_PAGE - PADDING_COUNT
    accessible(user).order(id: :desc).page(nil).per(count_for_first_page)
  end

  scope :for_accessible_list_second_page_or_later, ->(user, page) do
    # もし1ページ目が指定されても値を返さないようにする
    # （kaminariのissueによると、1ページ目でpaddingマイナス値を使うと不具合がある）
    return [] if ['1', 1, nil].include?(page)

    accessible(user).order(id: :desc).page(page).per(COUNT_PER_PAGE)
                    .padding(-PADDING_COUNT)
  end

  scope :accessible, ->(user) do
    owned_by(user).or(participated_in_by(user)).distinct
  end

  scope :owned_by, ->(user) do
    # .accessibleでorを使用できるようleft_joinsする
    left_joins(:participations).where(owner_id: user.id)
  end

  scope :participated_in_by, ->(user) do
    left_joins(:participations).where(participations: { user_id: user.id })
  end

  def accessible?(user)
    self.class.accessible(user).exists?(id)
  end

  def invite(user)
    invitations.build(user: user).save
  end

  def accessible_users
    [owner] + members
  end
end
