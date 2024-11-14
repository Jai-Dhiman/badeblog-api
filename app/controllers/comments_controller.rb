class CommentsController < ApplicationController
  before_action :authenticate_user
  before_action :set_story
  before_action :set_comment, only: [:update, :destroy]
  before_action :authorize_comment_owner!, only: [:update, :destroy]
  
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

  def update
    if @comment.update(comment_params)
      render json: @comment, serializer: CommentSerializer
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    head :no_content
  end
  
  private
  
  def set_story
    @story = Story.find(params[:story_id])
  end

  def set_comment
    @comment = @story.comments.find(params[:id])
  end
  
  def authorize_comment_owner!
    unless @comment.user_id == current_user.id || current_user.admin?
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end
  
  def comment_params
    params.require(:comment).permit(:content)
  end
end