class UsersController < ApplicationController
  before_action :authenticate_user, except: [:create]
  
def create
  user = User.new(user_params)
  if user.save
    jwt = JWT.encode(
      { user_id: user.id, exp: 24.hours.from_now.to_i },
      Rails.application.credentials.fetch(:secret_key_base),
      'HS256'
    )
    render json: { user: user, token: jwt }, status: :created
  else
    render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
  end
end
  
  def show
    user = User.find(params[:id])
    render json: user
  end
  
  def update
    if current_user.update(user_params)
      render json: current_user
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def profile
    render json: current_user
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :role)
  end
end