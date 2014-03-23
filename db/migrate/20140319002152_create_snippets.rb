class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.string :content
      t.integer :user_id
      t.string :source

      t.timestamps
    end
    add_index :snippets, [:user_id, :created_at]
  end
end
