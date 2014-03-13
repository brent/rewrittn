class User < ActiveRecord::Base
  before_save { self.email.downcase! }

  validates :name, presence: true, length: { maximum: 25 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }
  validates :password_confirmation, length: { minimum: 6 }

  has_secure_password
end
