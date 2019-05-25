module SessionsHelper
  def auth_path(provider)
    case provider
    when :google_oauth2
      '/auth/google_oauth2'
    when :twitter
      '/auth/twitter'
    when :github
      '/auth/github'
    end
  end
end
