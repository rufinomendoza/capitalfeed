desc "This task is called by the Heroku scheduler add-on"
  task :update_feed => :environment do

    puts "Cleaning garbage and old stories"
    @articles = FeedEntry.all
    @articles.each do |article|
      if article.category.nil? || article.published_at > 30.days.ago && article.category != "cm"
        article.destroy
      end
    end

    top_feeds = [
      'http://www.economist.com/feeds/print-sections/69/leaders.xml',
      'http://edge.org/feed',
      'http://bhorowitz.com/feed/',
      'http://www.foreignpolicy.com/node/feed',
      'http://www.ft.com/rss/lex',
      'http://www.kforcegov.com/NightWatch/rss.ashx'
    ]

    wire_feeds = [
      'http://feeds.businesswire.com/BW/Automotive_News-rss'
    ]

    cm_feeds = [
      'http://capitalmusings.com/feed'
    ]

    puts "Updating feeds for top stories"
    top_feeds.each do |feed|
      FeedEntry.update_from_feed(feed, 'top')
    end

    puts "Updating feeds from wires"
    wire_feeds.each do |feed|
      FeedEntry.update_from_feed(feed, 'wire')
    end

    puts "Updating feeds from Capital Musings"
    @cm_articles = FeedEntry.where("category = ?", "cm")
    @cm_articles.each { |article| article.destroy }
    cm_feeds.each do |feed|
      FeedEntry.update_from_feed(feed, 'cm')
    end

    puts "Done."
end