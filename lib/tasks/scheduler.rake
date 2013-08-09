desc "This task is called by the Heroku scheduler add-on"
  task :update_feed => :environment do
  puts "Updating feed..."
  FeedEntry.update_from_feed('http://www.economist.com/feeds/print-sections/69/leaders.xml')
  puts "done."
end