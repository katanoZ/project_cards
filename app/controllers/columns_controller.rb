class ColumnsController < ApplicationController
  before_action :set_project
  before_action :set_column, only: %i[edit update destroy previous next]
  before_action :set_operator, only: %i[update destroy]

  def new
    @column = @project.columns.build
  end

  def create
    @column = @project.columns.build(column_params)
    @column.operator = current_user

    if @column.save
      redirect_to project_path(@project), notice: 'カラムを作成しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @column.update(column_params)
      redirect_to project_path(@project), notice: 'カラムを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @column.destroy!
    redirect_to project_path(@project), notice: 'カラムを削除しました'
  end

  def previous
    @column.move_higher
    redirect_to project_path(@project)
  end

  def next
    @column.move_lower
    redirect_to project_path(@project)
  end

  private

  def column_params
    params.require(:column).permit(:name)
  end

  def set_project
    @project = Project.accessible(current_user).find(params[:project_id])
  end

  def set_column
    @column = @project.columns.find(params[:id])
  end

  def set_operator
    @column.operator = current_user
  end
end
