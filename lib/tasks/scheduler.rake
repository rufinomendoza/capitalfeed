desc "This task is called by the Heroku scheduler add-on"
  task :update_feed => :environment do
  puts "Updating feed..."
  FeedEntry.update_from_feed('http://feeds.reuters.com/reuters/businessNews?format=xml')
  puts "done."
end