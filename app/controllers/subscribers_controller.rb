class SubscribersController < ApplicationController
  before_action :ensure_frontend_url

  def create
    subscriber = Subscriber.new(subscriber_params)
    if subscriber.save
      render json: { message: "Successfully subscribed!" }, status: :created
    else
      render json: { errors: subscriber.errors.full_messages }, 
        status: :unprocessable_entity
    end
  end

  def unsubscribe
    Rails.logger.info "FRONTEND_URL: #{ENV['FRONTEND_URL']}"
    @subscriber = Subscriber.find_by!(unsubscribe_token: params[:token])
    if @subscriber.destroy
      redirect_url = "#{ENV['FRONTEND_URL']}?unsubscribed=true"
      Rails.logger.info "Redirecting to: #{redirect_url}"
      redirect_to redirect_url
    else
      redirect_to "#{ENV['FRONTEND_URL']}?unsubscribe_error=true"
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to "#{ENV['FRONTEND_URL']}?unsubscribe_error=invalid_token"
  end
  
  private

  def subscriber_params
    params.require(:subscriber).permit(:email)
  end

  def ensure_frontend_url
    unless ENV['FRONTEND_URL'].present?
      Rails.logger.error "FRONTEND_URL environment variable is not set!"
    end
  end
end