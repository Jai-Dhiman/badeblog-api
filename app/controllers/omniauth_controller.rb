class OmniauthController < ApplicationController
  def google_oauth2
    Rails.logger.info "OAuth callback received"
    auth = request.env['omniauth.auth']
    Rails.logger.info "Auth data: #{auth.inspect}"
    
    user = User.from_omniauth(auth)
    Rails.logger.info "User created/found: #{user.inspect}"
    
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
    Rails.logger.info "JWT created: #{jwt}"
    
    redirect_url = "#{ENV['FRONTEND_URL']}/auth/callback?token=#{jwt}"
    Rails.logger.info "Redirecting to: #{redirect_url}"
    
    redirect_to redirect_url
  end
  
  def failure
    Rails.logger.error "OAuth failure: #{params.inspect}"
    redirect_to "#{ENV['FRONTEND_URL']}/login?error=oauth_failure"
  end
end