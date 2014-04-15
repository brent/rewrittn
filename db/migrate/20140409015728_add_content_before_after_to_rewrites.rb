class AddContentBeforeAfterToRewrites < ActiveRecord::Migration
  def change
    change_table :rewrites do |t|
      t.rename :content, :content_before_snippet
      t.string :content_after_snippet
    end
  end
end
