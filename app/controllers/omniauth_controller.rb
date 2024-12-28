class OmniauthController < ApplicationController
  def google_oauth2
    user = User.from_omniauth(request.env['omniauth.auth'])
    
    jwt = JWT.encode(
      {
        user_id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        exp: 24.hours.from_now.to_i
      },
      Rails.application.credentials.fetch(:secret_key_base),
      'HS256'
    )

    frontend_url = ENV['FRONTEND_URL'] || 'https://www.myideasmywords.com'
    redirect_to "#{frontend_url}/auth/callback?token=#{jwt}"
  end

  def failure
    redirect_to "#{frontend_url}/login?error=oauth_failure"
  end
end