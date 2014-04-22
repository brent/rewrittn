class Rewrite < ActiveRecord::Base
  include PublicActivity::Common

  belongs_to :user
  belongs_to :snippet

  default_scope -> { order('created_at DESC') }

  validates :user_id,    presence: true
  validates :snippet_id, presence: true
  validates :title,      presence: true
  validate  :content

  def content
    if !content_before_snippet.present? && !content_after_snippet.present?
      errors.add(:base, "Your rewrite must have SOME content")
    end
  end

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", followed_user_ids: followed_user_ids, user_id: user)
  end
end
