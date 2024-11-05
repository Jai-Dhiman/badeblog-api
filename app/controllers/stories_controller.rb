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
  
  def reorder_photos
    photo_ids = params[:photo_ids]
    if @story.reorder_photos(photo_ids)
      render json: { message: 'Photos reordered successfully' }
    else
      render json: { error: 'Failed to reorder photos' }, status: :unprocessable_entity
    end
  end
  
  def photo_caption
    photo = @story.photos.find(params[:photo_id])
    if photo.update(caption: params[:caption])
      render json: { message: 'Caption updated successfully' }
    else
      render json: { error: 'Failed to update caption' }, status: :unprocessable_entity
    end
  end

  def recent
    stories = Story.published.includes(:category, :user).order(created_at: :desc).limit(5)
    render json: stories
  end
  
  def by_date
    stories = Story.published.where('created_at >= ?', params[:date]).includes(:category, :user).order(created_at: :desc)
    render json: stories
  end
  
  def search
    if params[:query].present?
      stories = Story.search_by_title_and_content(params[:query]).published.includes(:category, :user)
      render json: stories
    else
      render json: { error: 'Search query is required' }, status: :bad_request
    end
  end
  private
  
  def story_params
    params.require(:story).permit(:title, :content, :status, :category_id, :content_json, :plain_content)
  end
  
  def preview
    render json: @story, include: [:photos]
  end
  
  def autosave
    if @story.update(story_params.merge(status: 'draft'))
      render json: { message: 'Draft saved', story: @story }
    else
      render json: { errors: @story.errors.full_messages }, status: :unprocessable_entity
    end
  end
end