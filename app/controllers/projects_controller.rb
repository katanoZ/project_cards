class ProjectsController < ApplicationController
  def index
    @projects = Project.for_full_list(params[:page])
  end

  def show
    @project = Project.accessible(current_user)
                      .includes(columns: :cards)
                      .find(params[:id])
  end

  def info
    @project = Project.accessible(current_user)
                      .includes(:owner)
                      .find(params[:project_id])
    @members = @project.members.order(id: :asc)
  end
end
