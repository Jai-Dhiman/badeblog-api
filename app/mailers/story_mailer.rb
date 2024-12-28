class StoryMailer < ApplicationMailer
  def new_story_notification(subscriber, story)
    @story = story
    @subscriber = subscriber
    @unsubscribe_url = "#{ENV['BACKEND_URL'] || 'https://web-production-e3d6.up.railway.app'}/unsubscribe/#{@subscriber.unsubscribe_token}"
    
    mail(
      to: @subscriber.email,
      subject: "New Story Published on myideasmywords: #{@story.title}"
    )
  end
end