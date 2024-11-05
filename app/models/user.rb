class User < ApplicationRecord
  has_many :stories
  has_many :comments
  
  has_secure_password
  
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :username, presence: true, uniqueness: true

  store_accessor :preferences, :font_size, :high_contrast, 
  :simplified_interface, :text_to_speech_enabled
end