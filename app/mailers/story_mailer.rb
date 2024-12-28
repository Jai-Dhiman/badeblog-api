class StoryMailer < ApplicationMailer
  def new_story_notification(subscriber, story)
    @story = story
    @subscriber = subscriber
    @unsubscribe_url = Rails.application.routes.url_helpers.unsubscribe_url(
      token: @subscriber.unsubscribe_token,
      host: ENV['BACKEND_URL'] || 'https://web-production-e3d6.up.railway.app'
    )
    
    mail(
      to: @subscriber.email,
      subject: "New Story Published on myideasmywords: #{@story.title}"
    )
  end
end