class Card < ApplicationRecord
  belongs_to :assignee, class_name: 'User', foreign_key: :assignee_id
  belongs_to :project
  belongs_to :column

  acts_as_list scope: %i[project_id column_id]

  attr_accessor :operator

  validates :name, presence: true,
                   uniqueness: { scope: :project },
                   length: { maximum: 40 }
  validate :verify_assignee

  after_create CardCreateLogsCallbacks.new
  after_save CardSaveLogsCallbacks.new
  after_update CardUpdateLogsCallbacks.new
  after_destroy CardDestroyLogsCallbacks.new

  def move_to_higher_column
    return false if column.first?

    self.column = column.higher_item
    save
  end

  def move_to_lower_column
    return false if column.last?

    self.column = column.lower_item
    save
  end

  private

  def verify_assignee
    return if project.owner_id == assignee_id
    return if project.members.exists?(assignee_id)

    errors.add(:assignee, I18n.t('errors.messages.invalid'))
  end
end
