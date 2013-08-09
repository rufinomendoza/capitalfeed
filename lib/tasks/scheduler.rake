desc "This task is called by the Heroku scheduler add-on"
  task :update_feed => :environment do
    puts "Updating feeds"
    feeds = [
      'http://www.economist.com/feeds/print-sections/69/leaders.xml',
      'http://edge.org/feed',
      'http://capitalmusings.com/feed',
      'http://bhorowitz.com/feed/',
      'http://feeds.businesswire.com/BW/Automotive_News-rss',
      'http://www.foreignpolicy.com/node/feed',
      'http://www.ft.com/rss/lex',
      'http://www.kforcegov.com/NightWatch/rss.ashx'
    ]
    feeds.each do |feed|
      FeedEntry.update_from_feed(feed)
    end
    puts "Done."
end