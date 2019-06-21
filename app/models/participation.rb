class Participation < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :user, uniqueness: { scope: :project }
  validates :user, owner_rejection: true
end
