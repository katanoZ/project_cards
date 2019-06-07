class ProjectsController < ApplicationController
  def index
    @projects = Project.order(id: :desc).page(params[:page]).per(Project::COUNT_PER_PAGE)
  end
end
