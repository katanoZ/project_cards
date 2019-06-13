class Card < ApplicationRecord
  belongs_to :assignee, class_name: 'User', foreign_key: :assignee_id
  belongs_to :project
  belongs_to :column
end
