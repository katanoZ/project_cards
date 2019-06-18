class InvitationsController < ApplicationController
  before_action :set_project

  def invite
    @invitation_form = InvitationForm.new
  end

  def index
    @invitation_form = InvitationForm.new(invitation_params)
    @users = @invitation_form.search if @invitation_form.valid?
    render :invite
  end

  private

  def invitation_params
    params.require(:invitation).permit(:name)
  end

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end
end
