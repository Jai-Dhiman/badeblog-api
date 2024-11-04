class Api::V1::StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_story, except: [:index, :create, :drafts, :published]
  
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
      render json: { errors: @story.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @story.destroy
    head :no_content
  end
  
  def drafts
    stories = current_user.stories.where(status: 'draft')
    render json: stories
  end
  
  def published
    stories = current_user.stories.where(status: 'published')
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
  
  private
  
  def set_story
    @story = current_user.stories.find(params[:id])
  end
  
  def story_params
    params.require(:story).permit(:title, :content, :status, :category_id)
  end
end
