class AddIndexToFeedentries < ActiveRecord::Migration
  def change
    add_index :feed_entries, :guid
    add_index :feed_entries, :published_at
  end
end
