class Snippet < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }

  validates :user_id, presence: true
  validates :content, presence: true, length: { minimum: 50, maximum: 500 }
  validates :source, presence: true
end
