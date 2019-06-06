class Myprojects::ProjectsController < ApplicationController
  def index
    @projects = Project.where(owner: current_user).order(id: :desc).page(params[:page]).per(9)
    respond_to do |format|
      format.html
      format.js { render 'projects/index' }
    end
  end
end
