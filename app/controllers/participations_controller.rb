class ParticipationsController < ApplicationController
  def create
    project = current_user.invitation_projects.find(params[:project_id])
    if current_user.participate_in(project)
      redirect_to project_path(project), notice: 'プロジェクトに参加しました'
    else
      redirect_to project_path(project), alert: '処理に失敗しました'
    end
  end
end
