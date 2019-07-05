module LoginHelper
  def login(user)
    provider = user.provider
    uid = user.uid

    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new(
      provider: provider,
      uid: uid
    )

    Rails.application.env_config['omniauth.auth'] =
      OmniAuth.config.mock_auth[provider.to_sym]

    get '/auth/:provider/callback', params: { provider: provider }
  end
end
