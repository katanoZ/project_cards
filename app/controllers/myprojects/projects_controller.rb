class Myprojects::ProjectsController < ApplicationController
  def index
    @projects = Project.for_myprojects_list(current_user, params[:page])
    respond_to do |format|
      format.html
      format.js { render 'projects/index' }
    end
  end

  def new
    @project = current_user.projects.build
  end

  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      redirect_to myprojects_path, notice: 'プロジェクトを作成しました'
    else
      render :new
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :summary)
  end
end
