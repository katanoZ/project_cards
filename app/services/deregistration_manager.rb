class DeregistrationManager
  def initialize(user)
    @user = user
  end

  def destroy_user!
    User.transaction do
      manage_projects_for_user_deletion
      user.reload
      user.destroy!
    end
  end

  private

  attr_reader :user

  def manage_projects_for_user_deletion
    manage_owner_projects_for_user_deletion
    manage_member_projects_for_user_deletion
  end

  def manage_owner_projects_for_user_deletion
    user.owner_projects.each do |project|
      next unless project.members.exists?

      project.set_owner!(project.oldest_member)
      create_log_for_ownership_change!(project)
    end
  end

  def create_log_for_ownership_change!(project)
    project.logs.create!(content: content_for_ownership_change(project))
    project.logs.create!(content: content_for_deregistration)
  end

  def content_for_ownership_change(project)
    "プロジェクトオーナーの#{user.name}さんが退会するため、"\
    "最古メンバーの#{project.owner.name}さんが新しくオーナーになりました"
  end

  def content_for_deregistration
    "#{user.name}さんが退会しました"
  end

  def manage_member_projects_for_user_deletion
    user.member_projects.each do |project|
      create_log_for_deregistration!(project)
    end
  end

  def create_log_for_deregistration!(project)
    project.logs.create!(content: content_for_deregistration)
  end
end
