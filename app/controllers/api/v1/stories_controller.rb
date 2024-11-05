class Api::V1::StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_story, except: [:index, :create, :published]
  before_action :ensure_owner, only: [:update, :destroy]
  
  def index
    stories = Story.published.includes(:category, :user)
    render json: stories
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
    stories = Story.published.includes(:category, :user)
    render json: stories
  end
  
  def upload_photos
    if @story.photos.attach(params[:photos])
      render json: { message: 'Photos uploaded successfully' }
    else
      render json: { error: 'Failed to upload photos' }, status: :unprocessable_entity
    end
  end
  
  def remove_photo
    photo = @story.photos.find(params[:photo_id])
    photo.purge
    head :no_content
  end
  
  def by_date
    stories = Story.published.where('created_at >= ?', params[:date])
                   .includes(:category, :user)
                   .order(created_at: :desc)
    render json: stories
  end

  private
  
  def set_story
    @story = Story.find(params[:id])
  end
  
  def ensure_owner
    unless @story.user_id == current_user.id || current_user.admin?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  
  def story_params
    params.require(:story).permit(:title, :content, :status, :category_id)
  end
end