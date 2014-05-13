def clean_old_stories
  puts "Cleaning garbage and old stories"
  @articles = Article.all
  @articles.each do |article|
    if article.category.nil? || article.published_at.nil?
        article.destroy
    end
    if article.published_at.nil?
      article.destroy
    else
      if article.category != "cm" && article.published_at < 7.days.ago
        article.destroy
      end
    end
  end
  puts "Done cleansing."
  puts "\n\n"
end

def download_and_save(source, category = 'uncategorized', tag = '')
source.each do |feed|
    puts feed
    Article.update_from_feed(feed, category, tag)
    puts "\n"
  end
  puts "\n\n"
end


desc "This task is called by the Heroku scheduler add-on"

  desc "This is for cleaning the article DB"
    task :clean_article_database => :environment do
      puts "Completely cleaning database"
      @articles = Article.all
      @articles.each { |article| article.destroy }
      @tags = Tag.all
      @tags.each { |tag| tag.destroy }
      @taggings = Tagging.all
      @taggings.each { |tagging| tagging.destroy  }
      puts "\n\n"
      puts "Done."
  end

  task :clean_taggings => :environment do
    @taggings = Tagging.all
    @taggings = @taggings.each do |tagging|
      article_id = tagging.article_id
      tag_id = tagging.tag_id
      if Tag.where(:id => tag_id).exists? || Article.where(:id => article_id).exists? # Test for the Tag first
      else
        tagging.destroy
      end
    end
  end

  task :update_feed => :environment do

    # VARIABLES

    top_feeds = [
      'http://www.economist.com/feeds/print-sections/69/leaders.xml',
      'http://www.economist.com/rss/special_reports_rss.xml',
      'http://www.economist.com/rss/briefings_rss.xml',
      'http://www.economist.com/rss/books_and_arts_rss.xml'
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
      'http://www.economist.com/rss/business_rss.xml',
      'http://www.economist.com/rss/obituary_rss.xml',
      'http://www.economist.com/rss/indicators_rss.xml'
    ]

    cm_feeds = ['http://capitalmusings.com/feed']

    top_foreign_policy = [
      'http://www.kforcegov.com/NightWatch/rss.ashx',
      'http://www.foreignpolicy.com/node/feed',
      'http://www.economist.com/rss/international_rss.xml', 
      'http://www.foreignaffairs.com/rss.xml'
    ]

    top_tech = [
      'http://bhorowitz.com/blog.rss',
      'http://www.economist.com/rss/science_and_technology_rss.xml',
      'http://edge.org/feed',
      'http://feeds.wired.com/wiredinsights',
      'http://feeds.nature.com/nature/rss/current'
    ]

    top_business = [
      'http://www.economist.com/rss/finance_and_economics_rss.xml',
      'http://www.ft.com/rss/lex',
      'http://knowledge.wharton.upenn.edu/knowledgefeed.xml',
      'http://www.mckinsey.com/Insights/rss.aspx',
      'http://www.businessweek.com/feeds/homepage.rss'
    ]

    # Commands Begin Here
    # Clean first in case feed has been throwing errors
    clean_old_stories

    puts "Updating feeds for top stories"
    download_and_save top_feeds, 'top'
    puts "Updating feeds from wires"
    download_and_save wire_feeds, 'wire'
    puts "Updating feeds from Capital Musings"
    download_and_save cm_feeds, 'cm'
    puts "Top Foreign Policy"
    download_and_save top_foreign_policy, 'top', 'Politics'
    puts "Top Tech"
    download_and_save top_tech, 'top', 'Technology'
    puts "Top Business"
    download_and_save top_business, 'top', 'Business'
    puts "Done updating."
    puts "\n"

    # Final clean check
    clean_old_stories
end

desc "Wipe CM stories"
  task :wipe_cm => :environment do
    puts "Deleting old stories"
    @cm_articles = Article.where("category = ?", "cm")
    @cm_articles.each { |article| article.destroy }
end

desc "Update CM while deleting older articles"
  task :update_cm => :environment do
    cm_feeds = ['http://capitalmusings.com/feed']
    puts "Updating feeds from Capital Musings"
    download_and_save cm_feeds, 'cm'
end

desc "Mail article briefing"
  task :mail_news => :environment do
    @users = User.where("subscribed_to_daily_briefing = ?", true)
    @users.each do |user|
      puts user.email
      UserMailer.mail_news(user).deliver
    end
end
