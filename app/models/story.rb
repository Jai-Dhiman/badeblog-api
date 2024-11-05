class Story < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many_attached :photos
  
  validates :title, presence: true
  validates :content, presence: true
  validates :status, presence: true, inclusion: { in: %w[draft published] }
  
  include PgSearch::Model
  pg_search_scope :search_by_title_and_content,
    against: [:title, :content],
    using: {
      tsearch: { prefix: true }
    }

  def reorder_photos(photo_ids)
    transaction do
      photo_ids.each_with_index do |id, index|
        photos.find(id).update(position: index)
      end
    end
  end
  
  def touch_autosave
    update_column(:last_autosaved_at, Time.current)
  end
end
