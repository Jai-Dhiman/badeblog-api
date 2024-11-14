class StoriesController < ApplicationController
  before_action :authenticate_user, except: [:index, :show, :published]
  before_action :set_story, except: [:index, :create, :published]
  before_action :authorize_admin!, only: [:create, :update, :destroy]
  
  def index
    stories = Story.includes(:category, :user, :rich_text_content)
                  .order(created_at: :desc)
    render json: stories, root: false
  end
  
  def show
    render json: @story
  end
  
  def create
    story = current_user.stories.build(story_params)
    if story.save
      render json: story, status: :created
    else
      render json: { errors: story.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def update
    if @story.update(story_params)
      render json: @story
    else
      render json: { errors: story.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @story.destroy
    head :no_content
  end
  
  def published
    stories = Story.published.includes(:category, :user, :rich_text_content).order(creates_at: :desc)
    render json: stories
  end

  private
  
  def set_story
    @story = Story.find(params[:id])
  end
  
  def story_params
    if params[:story]
      params.require(:story).permit(:title, :content, :status, :category_id, :photo)
    else
      params.permit(:title, :content, :status, :category_id, :photo)
    end
  end

  def authorize_admin!
    unless current_user&.admin?
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end
end