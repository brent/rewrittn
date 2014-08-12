class User < ActiveRecord::Base
  has_many :snippets, dependent: :destroy
  has_many :rewrites, dependent: :destroy

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy

  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower

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

  def snippets_feed
    Snippet.from_users_followed_by(self)
  end

  def rewrites_feed
    Rewrite.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id, followed_type: "User")
  end

  def starred?(target)
    relationships.find_by(followed_id: target.id, followed_type: target.class.to_s)
  end

  def starred_snippets
    relationships.starred_snippets
  end

  def starred_rewrites
    relationships.starred_rewrites
  end

  def star!(target)
    relationships.create!(followed_id: target.id, followed_type: target.class.to_s)
  end

  def unstar!(target)
    relationships.find_by(followed_id: target.id, followed_type: target.class.to_s).destroy
  end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end
