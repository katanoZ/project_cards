class UsersController < ApplicationController
  before_action :set_user

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: 'アカウント情報を更新しました'
    else
      render :edit
    end
  end

  def destroy
    manager = DeregistrationManager.new(@user)
    manager.destroy_user!
    reset_session
    redirect_to login_path, notice: '退会が完了しました。ユーザーを削除しました。'
  end

  private

  def user_params
    params.require(:user).permit(:name, :new_image)
  end

  def set_user
    @user = current_user
  end
end
