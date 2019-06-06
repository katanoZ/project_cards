class Myprojects::ProjectsController < ApplicationController
  def index
    @projects = Project.where(owner: current_user).order(id: :desc).page(params[:page]).per(9)
    render 'projects/index'
  end
end
