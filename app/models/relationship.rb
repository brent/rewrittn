class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  scope :starred_snippets,  -> { where followed_type: "Snippet" }
  scope :starred_rewrites,  -> { where followed_type: "Rewrite" }

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
