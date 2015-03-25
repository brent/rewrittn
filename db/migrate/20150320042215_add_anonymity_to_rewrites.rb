class AddAnonymityToRewrites < ActiveRecord::Migration
  def change
    add_column :rewrites, :anonymous, :boolean, default: true
  end
end
