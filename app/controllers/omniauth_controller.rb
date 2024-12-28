class OmniauthController < ApplicationController
  def google_oauth2
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(auth)
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
    
    redirect_to "#{ENV['FRONTEND_URL']}/auth/callback?token=#{jwt}", allow_other_host: true
  end

  def failure
    Rails.logger.error "OAuth failure: #{params.inspect}"
    redirect_to "#{ENV['FRONTEND_URL']}/login?error=oauth_failure", allow_other_host: true
  end
end