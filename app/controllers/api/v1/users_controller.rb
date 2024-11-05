class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:create]
  
  def create
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { user: user, token: token }, status: :created
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
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end