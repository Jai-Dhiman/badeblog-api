class CategoriesController < ApplicationController
  def index
    categories = Category.all
    render json: categories, each_serializer: CategorySerializer
  end
  
  def show
    category = Category.find(params[:id])
    render json: category, serializer: CategorySerializer
  end
  
  def stories
    Rails.logger.info "Received request for category stories: #{params.inspect}"
    category = Category.find(params[:id])
    stories = category.stories.published
    Rails.logger.info "Found #{stories.count} stories"
    render json: stories, each_serializer: StorySerializer
  rescue => e
    Rails.logger.error "Error fetching stories: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: { error: e.message }, status: :not_found
  end
end