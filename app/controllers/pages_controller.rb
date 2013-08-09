class PagesController < ApplicationController
  def home
  end

  def about
  end

  def articles
    feeds = [
      'http://www.economist.com/feeds/print-sections/69/leaders.xml',
      'http://edge.org/feed',
      'http://capitalmusings.com/feed',
      'http://bhorowitz.com/feed/',
      'http://feeds.businesswire.com/BW/Automotive_News-rss',
      'http://www.foreignpolicy.com/node/feed',
      'http://www.ft.com/rss/lex'
    ]
    feeds.each do |feed|
      FeedEntry.update_from_feed(feed)
    end
    @articles = FeedEntry.order("published_at desc").page(params[:page]).per_page(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
      format.js
    end

  end
end
