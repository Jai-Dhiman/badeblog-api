class Story < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_one_attached :photo
  has_rich_text :content
  
  validates :title, presence: true
  validates :content, presence: true
  validates :status, presence: true, inclusion: { in: %w[draft published] }
  validates :category_id, presence: true
  validates :user_id, presence: true
  

  default_scope { order(published_at: :desc) }
  scope :published, -> { where(status: 'published') }
  before_save :set_published_at

  after_save :notify_subscribers_if_published

  private 

  def set_published_at
    if status_changed? && status == 'published'
      self.published_at = Time.current
    end
  end

  def notify_subscribers_if_published
    if saved_change_to_status? && status == "published"
      Subscriber.find_each do |subscriber|
        StoryMailer.new_story_notification(subscriber, self).deliver_later
      end
    end
  end
end