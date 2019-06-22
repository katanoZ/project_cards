class Myprojects::ProjectsController < ApplicationController
  before_action :set_project, only: %i[edit update destroy]

  def index
    @projects = Project.for_accessible_list(current_user, params[:page])
    respond_to do |format|
      format.html
      format.js { render 'projects/index' }
    end
  end

  def new
    @project = current_user.owner_projects.build
  end

  def create
    @project = current_user.owner_projects.build(project_params)

    if @project.save
      redirect_to projects_path, notice: 'プロジェクトを作成しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path, notice: 'プロジェクトを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @project.destroy!
    redirect_to projects_path, notice: 'プロジェクトを削除しました'
  end

  private

  def project_params
    params.require(:project).permit(:name, :summary)
  end

  def set_project
    @project = current_user.owner_projects.find(params[:id])
  end
end
