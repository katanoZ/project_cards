class ProjectsController < ApplicationController
  def index
    @projects = Project.for_list(params[:page])
  end
end
