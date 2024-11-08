class StoriesController < ApplicationController
  # before_action :authenticate_user
  # before_action :set_story, except: [:index, :create, :published]
  # before_action :ensure_owner, only: [:update, :destroy]
  
  # def index
  #   stories = Story.all.includes(:category, :user, :rich_text_content)
  #   render json: stories
  # end
  
  def show
    p "hello"
    @story = Story.first
    # render json: @story
    render :show
  end
  
  # def create
  #   story = current_user.stories.build(story_params)
  #   if story.save
  #     render json: story, status: :created
  #   else
  #     render json: { errors: story.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end
  
  # def update
  #   if @story.update(story_params)
  #     render json: @story
  #   else
  #     render json: { errors: story.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end
  
  # def destroy
  #   @story.destroy
  #   head :no_content
  # end
  
  # def published
  #   stories = Story.published.includes(:category, :user, :rich_text_content)
  #   render json: stories
  # end

  # private
  
  # def set_story
  #   @story = Story.find(params[:id])
  # end
  
  # def story_params
  #   params.require(:story).permit(:title, :content, :status, :category_id, :photo)
  # end
end