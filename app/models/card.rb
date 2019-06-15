class Card < ApplicationRecord
  belongs_to :assignee, class_name: 'User', foreign_key: :assignee_id
  belongs_to :project
  belongs_to :column

  acts_as_list scope: %i[project_id column_id]

  validates :name, presence: true,
                   uniqueness: { scope: :project },
                   length: { maximum: 40 }

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
end
