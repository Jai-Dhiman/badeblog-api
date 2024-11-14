class CommentsController < ApplicationController
  before_action :authenticate_user
  before_action :set_story
  
  def index
    comments = @story.comments.includes(:user)
    render json: comments, each_serializer: CommentSerializer
  end
  
  def create
    comment = @story.comments.build(comment_params)
    comment.user = current_user
    
    if comment.save
      render json: comment, serializer: CommentSerializer, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_story
    @story = Story.find(params[:story_id])
  end
  
  def comment_params
    params.permit(:content)
  end
end