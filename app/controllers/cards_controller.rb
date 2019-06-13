class CardsController < ApplicationController
  before_action :set_project
  before_action :set_column

  def new
    @card = @column.cards.build
    @card.assignee = current_user
  end

  def create
    @card = @column.cards.build(card_params)
    @card.project = @project

    if @card.save
      redirect_to project_path(@project), notice: 'カードを作成しました'
    else
      render :new
    end
  end

  private

  def card_params
    params.require(:card).permit(:name, :due_date, :assignee_id)
  end

  def set_project
    @project = Project.accessible(current_user).find(params[:project_id])
  end

  def set_column
    @column = @project.columns.find(params[:column_id])
  end
end
