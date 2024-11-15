class User < ApplicationRecord
  has_many :stories
  has_many :comments
  
  has_secure_password
  
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: %w[admin user] }
  
  def admin?
    role == 'admin'
  end
end