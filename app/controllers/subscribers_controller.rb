class SubscribersController < ApplicationController
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
    @subscriber = Subscriber.find_by!(unsubscribe_token: params[:token])
    if @subscriber.destroy
      redirect_to "#{ENV['FRONTEND_URL']}?unsubscribed=true"
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
end