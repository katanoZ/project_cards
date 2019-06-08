class ProjectsController < ApplicationController
  def index
    @projects = Project.for_full_list(params[:page])
  end
end
