class ProjectsController < ApplicationController
  def index
    @projects = Project.for_full_list(params[:page])
  end

  def show
    @project = Project.accessible(current_user).find(params[:id])
  end
end
