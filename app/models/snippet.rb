class Snippet < ActiveRecord::Base
  include PublicActivity::Common

  belongs_to :user
  has_many :rewrites
  default_scope -> { order('created_at DESC') }

  validates :user_id, presence: true
  validates :content, presence: true, length: { minimum: 50, maximum: 500 }
  validates :source, presence: true

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", followed_user_ids: followed_user_ids, user_id: user)
  end
end
