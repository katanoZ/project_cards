class InvitationCreateLogsCallbacks
  def content(invitation)
    "#{invitation.project.owner.name}さんが#{invitation.user.name}さんをこのプロジェクトに招待しました"
  end

  private

  def after_create(invitation)
    Log.create!(content: content(invitation), project: invitation.project)
  end
end
