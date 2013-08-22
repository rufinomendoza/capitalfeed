desc "This task is called by the Heroku scheduler add-on"
  task :update_feed => :environment do

    puts "Cleaning garbage and old stories"
    @articles = FeedEntry.all
    @articles.each do |article|
      puts article.published_at
      puts "\n"
      if article.category.nil?
          article.destroy
      end
      unless article.published_at.nil?
        if article.category != "cm" && article.published_at > 7.days.ago
          article.destroy
        end
      end
    end
    puts "\n\n"

    top_feeds = [
      'http://www.economist.com/feeds/print-sections/69/leaders.xml',
      'http://www.economist.com/rss/special_reports_rss.xml',
      'http://www.economist.com/rss/briefings_rss.xml',
      'http://www.economist.com/rss/science_and_technology_rss.xml',
      'http://www.economist.com/rss/books_and_arts_rss.xml',
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
      # 'http://www.prnewswire.com/rss/news-for-investors-from-PR-Newswire-news.rss',
      'http://www.prnewswire.com/rss/auto-transportation/automotive-news.rss',
      'http://feeds.feedburner.com/TheAtlantic?format=xml',
      'http://feeds.feedburner.com/TheAtlanticWire?format=xml',
      'http://feeds.feedburner.com/TheAtlanticCities?format=xml',
      'http://www.economist.com/rss/britain_rss.xml',
      'http://www.economist.com/rss/europe_rss.xml',
      'http://www.economist.com/rss/united_states_rss.xml',
      'http://www.economist.com/rss/the_americas_rss.xml',
      'http://www.economist.com/rss/middle_east_and_africa_rss.xml',
      'http://www.economist.com/rss/asia_rss.xml',
      'http://www.economist.com/rss/china_rss.xml',
      'http://www.economist.com/rss/international_rss.xml',
      'http://www.economist.com/rss/business_rss.xml',
      'http://www.economist.com/rss/finance_and_economics_rss.xml',
      'http://www.economist.com/rss/obituary_rss.xml',
      'http://www.economist.com/rss/indicators_rss.xml'
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

desc "This is for cleaning the article DB"
  task :clean_database => :environment do
    puts "Completely cleaning database"
    @articles = FeedEntry.all
    @articles.each do |article|
      article.destroy
    end
    puts "\n\n"

    puts "Done."
end