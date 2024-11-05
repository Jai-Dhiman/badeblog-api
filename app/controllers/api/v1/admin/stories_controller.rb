class Api::V1::Admin::StoriesController < Api::V1::Admin::BaseController
  def index
    stories = current_user.stories.with_deleted
    render json: stories
  end
  
  def restore
    story = current_user.stories.only_deleted.find(params[:id])
    if story.restore
      render json: story
    else
      render json: { errors: story.errors.full_messages }, status: :unprocessable_entity
    end
  end
end