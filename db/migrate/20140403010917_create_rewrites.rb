class CreateRewrites < ActiveRecord::Migration
  def change
    create_table :rewrites do |t|
      t.string :title
      t.string :content
      t.integer :user_id
      t.integer :snippet_id

      t.timestamps
    end
    add_index :rewrites, [:user_id, :snippet_id, :created_at]
  end
end
