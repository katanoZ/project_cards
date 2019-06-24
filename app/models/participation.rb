class Participation < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :user, uniqueness: { scope: :project }
  validates :user, owner_rejection: true

  before_create :destroy_invitation!, if: :invited?

  def invited?
    user.invited?(project)
  end

  private

  def destroy_invitation!
    user.invitations.find_by!(project_id: project.id).destroy!
  end
end
