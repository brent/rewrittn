class User < ActiveRecord::Base
  has_many :snippets, dependent: :destroy

  before_save { self.email.downcase! }
  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 25 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }
  validates :password_confirmation, length: { minimum: 6 }

  has_secure_password

  def User.new_remember_token
    SecureRandom::urlsafe_base64
  end

  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Snippet.where("user_id = ?", id)
  end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end
