class Myprojects::ProjectsController < ApplicationController
  def index
    @projects = Project.for_myprojects_list(current_user, params[:page])
    respond_to do |format|
      format.html
      format.js { render 'projects/index' }
    end
  end
end
