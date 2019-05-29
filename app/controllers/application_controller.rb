class ApplicationController < ActionController::Base
  before_action :redirect_not_logged_in_user_to_login_page

  if Rails.env.staging?
    http_basic_authenticate_with name: ENV.fetch('BASIC_AUTH_USERNAME'),
                                 password: ENV.fetch('BASIC_AUTH_PASSWORD')
  end

  helper_method :logged_in?, :current_user

  private

  def redirect_not_logged_in_user_to_login_page
    redirect_to login_path, alert: 'ログインしてください' unless logged_in?
  end

  def logged_in?
    session[:user_id].present?
  end

  def current_user
    return unless logged_in?

    @current_user ||= User.find(session[:user_id])
  end
end
