class RemoveUniqueFromRelationshipsFollowerId < ActiveRecord::Migration
  def change
    change_column :relationships, :followed_id, :string, unique: false
  end
end
