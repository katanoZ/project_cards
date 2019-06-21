class Invitation < ApplicationRecord
  belongs_to :project
  belongs_to :user

  paginates_per 5

  validates :user, uniqueness: { scope: :project }
  validates :user, owner_rejection: true
end
