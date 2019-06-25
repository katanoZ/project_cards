class CardsController < ApplicationController
  before_action :set_project
  before_action :set_column
  before_action :set_card, only: %i[edit update destroy previous next]
  before_action :set_operator, only: %i[update destroy]

  def new
    @card = @column.cards.build
    @card.assignee = current_user
  end

  def create
    @card = @column.cards.build(card_params)
    @card.project = @project
    @card.operator = current_user

    if @card.save
      redirect_to project_path(@project), notice: 'カードを作成しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @card.update(card_params)
      redirect_to project_path(@project), notice: 'カードを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @card.destroy!
    redirect_to project_path(@project), notice: 'カードを削除しました'
  end

  def previous
    @card.move_to_higher_column
    redirect_to project_path(@project)
  end

  def next
    @card.move_to_lower_column
    redirect_to project_path(@project)
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

  def set_card
    @card = @column.cards.find(params[:id])
  end

  def set_operator
    @card.operator = current_user
  end
end
