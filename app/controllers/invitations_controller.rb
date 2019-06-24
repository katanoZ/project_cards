class InvitationsController < ApplicationController
  before_action :set_project

  def invite
    @invitation_form = InvitationForm.new
  end

  def generate_invitaions
    @invitation_form = InvitationForm.new(invitation_params)
    @users = @invitation_form.search if @invitation_form.valid?
    render :invite
  end

  def create
    user = User.find(params[:user_id])
    if @project.invite(user)
      redirect_to project_path(@project), notice: "#{user.name}さんをプロジェクトに招待しました"
    else
      redirect_to project_path(@project), alert: '処理に失敗しました'
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:name)
  end

  def set_project
    @project = current_user.owner_projects.find(params[:project_id])
  end
end
