class Myprojects::ProjectsController < ApplicationController
  def index
    @projects = Project.where(owner: current_user)
    render 'projects/index'
  end
end
