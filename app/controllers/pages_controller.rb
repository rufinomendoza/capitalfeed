class PagesController < ApplicationController
  def home
  end

  def about
  end

  def articles
    feeds = [
      'http://www.economist.com/feeds/print-sections/69/leaders.xml',
      'http://edge.org/feed',
      'http://feeds.reuters.com/reuters/businessNews'
    ]
    feeds.each do |feed|
      FeedEntry.update_from_feed(feed)
    end
  end
end
