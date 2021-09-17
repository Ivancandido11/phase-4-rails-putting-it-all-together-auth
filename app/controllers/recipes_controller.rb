class RecipesController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_response

  def index
    if session[:user_id]
      recipes = Recipe.all
      render json: recipes, include: :user, status: :created
    else
      render json: { errors: ["User not logged in"] }, status: :unauthorized
    end
  end

  def create
    if session[:user_id]
      recipe = Recipe.create!(user_id: session[:user_id], title: params[:title],
                              instructions: params[:instructions], minutes_to_complete: params[:minutes_to_complete])
      render json: recipe, include: :user, status: :created
    else
      render json: { errors: ["User not logged in"] }, status: :unauthorized
    end
  end

private

  def recipe_params
    params.permit(:user_id, :title, :instructions, :minutes_to_complete)
  end

  def render_invalid_response(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end
end
