Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.credentials.google_oauth2[:key],
           Rails.application.credentials.google_oauth2[:secret],
           image_aspect_ratio: 'square'

  provider :twitter,
           Rails.application.credentials.twitter[:key],
           Rails.application.credentials.twitter[:secret],
           image_size: 'original'

  provider :github,
           Rails.application.credentials.github[:key],
           Rails.application.credentials.github[:secret]
end
