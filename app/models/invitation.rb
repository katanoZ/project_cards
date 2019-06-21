class Invitation < ApplicationRecord
  belongs_to :project
  belongs_to :user

  paginates_per 5

  validates :user, uniqueness: { scope: :project }
  validate :verify_owner

  private

  def verify_owner
    errors.add(:user, I18n.t('errors.messages.invalid')) if user.owner?(project)
  end
end
