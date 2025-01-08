class StatsController < ApplicationController
  before_action :authenticate_user
  before_action :require_admin

  def subscriber_list
    subscribers = Subscriber.select(:email).all
    render json: { 
      count: subscribers.count,
      subscribers: subscribers.map(&:email)
    }
  end

  def recent_comments
    recent_comments = Comment.includes(:user, :story)
                           .where('created_at >= ?', 1.week.ago)
                           .order(created_at: :desc)
    
    render json: {
      data: recent_comments.map do |comment|
        {
          id: comment.id,
          type: 'comment',
          attributes: {
            content: comment.content,
            'created-at': comment.created_at,
            'updated-at': comment.updated_at,
            'user-info': {
              id: comment.user.id,
              name: comment.user.name
            },
            'story-info': {
              id: comment.story.id,
              title: comment.story.title
            }
          }
        }
      end
    }
  end

  private

  def require_admin
    unless current_user.admin?
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end
end