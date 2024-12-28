class User < ApplicationRecord
  has_many :stories
  has_many :comments
  has_secure_password validations: false 
  
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: %w[admin user] }
  
  def self.from_omniauth(auth)
    user = User.find_or_initialize_by(email: auth.info.email)
    
    user.provider = auth.provider
    user.uid = auth.uid
    user.name = auth.info.name
    user.role = 'user'
    user.password = SecureRandom.hex(10) if user.new_record?
    
    user.save!
    user
  end

  def admin?
    role == 'admin'
  end
end