class SessionsController < ApplicationController
  skip_before_action :redirect_not_logged_in_user_to_login_page

  def new
  end

  def create
    user = User.find_or_create_from_auth(request.env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to root_path, notice: user.login_message
  end
end
