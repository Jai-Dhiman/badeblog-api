class Story < ApplicationRecord
  act_as_paranoid

  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many_attached :photos
  
  validates :title, presence: true
  validates :content, presence: true
  validates :status, presence: true, inclusion: { in: %w[draft published] }
  

  scope :admin_stories, -> { joins(:user).where(users: { role: 'admin' }) }
end