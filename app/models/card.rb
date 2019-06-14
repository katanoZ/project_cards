class Card < ApplicationRecord
  belongs_to :assignee, class_name: 'User', foreign_key: :assignee_id
  belongs_to :project
  belongs_to :column

  validates :name, presence: true,
                   uniqueness: { scope: :project },
                   length: { maximum: 40 }
end
