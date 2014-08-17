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

  def self.reading_list
    select("rewrites.*, COUNT(*) AS stars_count, relationships.followed_id")
    .joins("INNER JOIN relationships ON rewrites.id = relationships.followed_id")
    .where("relationships.followed_type = 'Rewrite'")
    .group("relationships.followed_id")
    .order("stars_count DESC")

    # find_by_sql("SELECT rewrites.*, COUNT(*) AS stars_count, relationships.followed_id FROM rewrites INNER JOIN relationships ON rewrites.id = relationships.followed_id WHERE relationships.followed_type = 'Rewrite' GROUP BY relationships.followed_id ORDER BY stars_count DESC")
  end
end
