desc "This task is called by the Heroku scheduler add-on"
  task :update_feed => :environment do

    puts "Cleaning garbage and old stories"
    @articles = FeedEntry.all
    @articles.each do |article|
      if article.category.nil? || article.published_at > 7.days.ago && article.category != "cm"
        article.destroy
      end
    end
    puts "\n\n"

    top_feeds = [
      'http://www.economist.com/feeds/print-sections/69/leaders.xml',
      'http://edge.org/feed',
      'http://bhorowitz.com/feed/',
      'http://www.foreignpolicy.com/node/feed',
      'http://www.ft.com/rss/lex',
      'http://www.kforcegov.com/NightWatch/rss.ashx'
    ]

    wire_feeds = [
      'http://feeds.businesswire.com/BW/Automotive_News-rss',
      'http://feeds.businesswire.com/BW/Bankruptcy_News-rss',
      'http://feeds.businesswire.com/BW/Bond_Issue_News-rss',
      'http://feeds.businesswire.com/BW/Conference_Calls-rss',
      'http://feeds.businesswire.com/BW/Earnings_News-rss',
      'http://feeds.businesswire.com/BW/Filing_News-rss',
      'http://feeds.businesswire.com/BW/Hedge_Fund_News-rss',
      'http://feeds.businesswire.com/BW/IPO_News-rss',
      'http://feeds.businesswire.com/BW/Investment_Opinion_News-rss',
      'http://www.prnewswire.com/rss/news-for-investors-from-PR-Newswire-news.rss',
      'http://www.prnewswire.com/rss/auto-transportation/automotive-news.rss'
    ]

    cm_feeds = [
      'http://capitalmusings.com/feed'
    ]

    puts "Updating feeds for top stories"
    top_feeds.each do |feed|
      puts feed
      FeedEntry.update_from_feed(feed, 'top')
    end
    puts "\n\n"

    puts "Updating feeds from wires"
    wire_feeds.each do |feed|
      puts feed
      FeedEntry.update_from_feed(feed, 'wire')
      puts ''
    end
    puts "\n\n"

    puts "Updating feeds from Capital Musings"
    @cm_articles = FeedEntry.where("category = ?", "cm")
    @cm_articles.each { |article| article.destroy }
    cm_feeds.each do |feed|
      puts feed
      FeedEntry.update_from_feed(feed, 'cm')
    end
    puts "\n\n"

    puts "Done."
end