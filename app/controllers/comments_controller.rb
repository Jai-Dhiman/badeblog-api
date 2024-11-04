class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_story
  before_action :set_comment, only: [:update, :destroy]
  
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
  
  def update
    if @comment.user == current_user && @comment.update(comment_params)
      render json: @comment
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    if @comment.user == current_user
      @comment.destroy
      head :no_content
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  
  private
  
  def set_story
    @story = Story.find(params[:story_id])
  end
  
  def set_comment
    @comment = @story.comments.find(params[:id])
  end
  
  def comment_params
    params.require(:comment).permit(:content)
  end
end
