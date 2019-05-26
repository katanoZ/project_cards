Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.credentials.google_oauth2[:key],
           Rails.application.credentials.google_oauth2[:secret]

  provider :twitter,
           Rails.application.credentials.twitter[:key],
           Rails.application.credentials.twitter[:secret]

  provider :github,
           Rails.application.credentials.github[:key],
           Rails.application.credentials.github[:secret]
end
