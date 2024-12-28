Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, 
    ENV['GOOGLE_CLIENT_ID'],
    ENV['GOOGLE_CLIENT_SECRET'],
    {
      scope: 'email,profile',
      prompt: 'select_account',
      image_aspect_ratio: 'square',
      image_size: 50,
      redirect_uri: proc { |env| 
        if Rails.env.production?
          "https://web-production-e3d6.up.railway.app/auth/google_oauth2/callback"
        else
          "http://localhost:3000/auth/google_oauth2/callback"
        end
      }
    }
end

OmniAuth.config.allowed_request_methods = [:post, :get]
OmniAuth.config.silence_get_warning = true