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
end