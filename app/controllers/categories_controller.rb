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
    category = Category.find(params[:id])
    stories = category.stories.published
    render json: stories, each_serializer: StorySerializer
  end
end