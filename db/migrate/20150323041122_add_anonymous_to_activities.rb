class AddAnonymousToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :anonymous, :boolean, default: true
    add_index :activities, :anonymous
  end
end
