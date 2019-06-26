class ParticipationCreateLogsCallbacks
  def content(participation)
    "#{participation.user.name}さんがこのプロジェクトに参加しました"
  end

  private

  def after_create(participation)
    Log.create!(content: content(participation), project: participation.project)
  end
end
