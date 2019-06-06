class ProjectsController < ApplicationController
  def index
    @projects = Project.order(id: :desc).page(params[:page]).per(9)
  end
end
