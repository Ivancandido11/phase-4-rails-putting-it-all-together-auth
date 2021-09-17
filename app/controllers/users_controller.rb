class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_response

  def create
    user = User.create!(user_params)
    session[:user_id] = user.id
    render json: user, status: :created
  end

  def show
    user = User.find_by(id: session[:user_id])
    if user
      render json: user, status: :created
    else
      render json: { error: "Not Authorized" }, status: :unauthorized
    end
  end

private

  def user_params
    params.permit(:username, :password, :password_confirmation, :image_url, :bio)
  end

  def render_invalid_response(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end
end
