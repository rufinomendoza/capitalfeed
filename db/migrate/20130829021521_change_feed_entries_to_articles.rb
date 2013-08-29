class ChangeFeedEntriesToArticles < ActiveRecord::Migration
  def up
    rename_table :feed_entries, :articles
  end

  def down
    rename_table :articles, :feed_entries
  end
end
