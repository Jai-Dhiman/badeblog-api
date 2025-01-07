class StoryMailer < ApplicationMailer
  def custom_story_notification(subscriber, story, custom_message)
    @story = story
    @subscriber = subscriber
    @custom_message = custom_message
    @unsubscribe_url = "#{ENV['BACKEND_URL'] || 'https://web-production-e3d6.up.railway.app'}/unsubscribe/#{@subscriber.unsubscribe_token}"
    
    mail(
      to: @subscriber.email,
      subject: "New Story #{@story.title} published by PR Dhiman"
    )
  end
end