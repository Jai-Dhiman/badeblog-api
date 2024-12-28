class StoryMailer < ApplicationMailer
  def new_story_notification(subscriber, story)
    @story = story
    @subscriber = subscriber
    mail(
      to: @subscriber.email,
      subject: "New Story Published on myideasmywords: #{@story.title}"
    )
  end
end