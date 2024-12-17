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

  private

  def subscriber_params
    params.require(:subscriber).permit(:email)
  end
end