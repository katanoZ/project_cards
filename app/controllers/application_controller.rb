class ApplicationController < ActionController::Base
  if Rails.env.staging?
    http_basic_authenticate_with name: ENV.fetch('BASIC_AUTH_USERNAME'),
                                 password: ENV.fetch('BASIC_AUTH_PASSWORD')
  end
end
