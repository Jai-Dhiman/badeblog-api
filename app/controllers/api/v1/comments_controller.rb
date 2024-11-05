class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_story
  
  def index
    comments = @story.comments.includes(:user)
    render json: comments
  end
  
  def create
    comment = @story.comments.build(comment_params)
    comment.user = current_user
    
    if comment.save
      render json: comment, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_story
    @story = Story.find(params[:story_id])
  end
  
  def comment_params
    params.require(:comment).permit(:content)
  end
end