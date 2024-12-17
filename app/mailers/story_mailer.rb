class StoryMailer < ApplicationMailer
  def new_story_notification(subscriber, story)
    @story = story
    @subscriber = subscriber
    mail(
      to: @subscriber.email,
      subject: "New Story Published: #{@story.title}"
    )
  end
end