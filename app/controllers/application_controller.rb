class ApplicationController < ActionController::Base
  before_action :redirect_not_logged_in_user_to_login_page

  if Rails.env.staging?
    http_basic_authenticate_with name: ENV.fetch('BASIC_AUTH_USERNAME'),
                                 password: ENV.fetch('BASIC_AUTH_PASSWORD')
  end

  private

  def redirect_not_logged_in_user_to_login_page
    redirect_to login_path, alert: 'ログインしてください' unless logged_in?
  end

  def logged_in?
    session[:user_id].present?
  end
end
