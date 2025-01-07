class StoriesController < ApplicationController
  before_action :authenticate_user, except: [:index, :show, :published]
  before_action :set_story, except: [:index, :create, :published, :drafts]
  before_action :authorize_admin!, only: [:create, :update, :destroy, :drafts, :send_notification]

  def index
    stories = Story.includes(:category, :user, :rich_text_content)
                  .published
                  .order(published_at: :desc, created_at: :desc)
    render json: stories, root: false
  end
  
  def show
    render json: @story
  end
  
  def create
    story = current_user.stories.build(story_params)
    if story.save
      notify_subscribers if story.status == 'published'
      render json: story, status: :created
    else
      render json: { errors: story.errors.full_messages }, 
        status: :unprocessable_entity
    end
  end
  
  def update
    content = story_params[:content]
    
    if content.present? && content.include?('class="trix-content"')
      doc = Nokogiri::HTML::DocumentFragment.parse(content)
      trix_content = doc.css('.trix-content').first
      content = trix_content ? trix_content.inner_html : content
    end
    
    update_params = story_params.merge(content: content)
    
    if @story.update(update_params)
      render json: @story
    else
      render json: { errors: @story.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @story.destroy
    head :no_content
  end
  
  def published
    stories = Story.published
                  .includes(:category, :user, :rich_text_content)
                  .order(published_at: :desc, created_at: :desc)
    render json: stories
  end

  def drafts
    stories = Story.where(status: 'draft')
                  .includes(:category, :user, :rich_text_content)
                  .order(created_at: :desc)
    render json: stories
  end

  def send_notification
    @story = Story.find(params[:id])
    custom_message = params[:message]
    
    Subscriber.find_each do |subscriber|
      StoryMailer.custom_story_notification(subscriber, @story, custom_message).deliver_later
    end
    
    render json: { message: 'Notifications sent successfully' }
  rescue => e
    Rails.logger.error "Notification error: #{e.message}"
    render json: { error: e.message }, status: :unprocessable_entity
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