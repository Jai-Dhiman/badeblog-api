class Subscriber < ApplicationRecord
  before_create :generate_unsubscribe_token
  
  validates :email, presence: true, uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP }
  
  private
  
  def generate_unsubscribe_token
    self.unsubscribe_token = SecureRandom.urlsafe_base64
  end
end