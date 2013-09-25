desc "This task is called by the Heroku scheduler add-on"

  desc "This is for cleaning the article DB"
    task :clean_database => :environment do
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

    puts "Cleaning garbage and old stories"
    @articles = Article.all
    @articles.each do |article|
      if article.category.nil? || article.published_at.nil?
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
      'http://www.economist.com/rss/business_rss.xml',
      'http://www.economist.com/rss/obituary_rss.xml',
      'http://www.economist.com/rss/indicators_rss.xml'
    ]



    puts "Updating feeds for top stories"
    top_feeds.each do |feed|
      puts feed
      Article.update_from_feed(feed, 'top')
    end
    puts "\n\n"

    puts "Updating feeds from wires"
    wire_feeds.each do |feed|
      puts feed
      Article.update_from_feed(feed, 'wire')
    end
    puts "\n\n"


    cm_feeds = [
      'http://capitalmusings.com/feed'
    ]

    puts "Updating feeds from Capital Musings"
    # @cm_articles = Article.where("category = ?", "cm")
    # @cm_articles.each { |article| article.destroy }
    cm_feeds.each do |feed|
      puts feed
      Article.update_from_feed(feed, 'cm')
    end
    puts "\n\n"

    # TOP NEWS
    # Foreign Policy Tag Test
    puts "Top FP"
    top_foreign_policy = [
      'http://www.kforcegov.com/NightWatch/rss.ashx',
      'http://www.foreignpolicy.com/node/feed',
      'http://www.economist.com/rss/international_rss.xml', 
      'http://www.foreignaffairs.com/rss.xml'
    ]
    top_foreign_policy.each do |feed|
      puts feed
      Article.update_from_feed(feed, 'top', 'Politics')
    end

    # Tech
    puts "Top Tech"
    top_tech = [
      'http://bhorowitz.com/feed/',
      'http://www.economist.com/rss/science_and_technology_rss.xml',
      'http://edge.org/feed',
      'http://feeds.wired.com/wiredinsights'
      # 'http://feeds.nature.com/nature/rss/current'
    ]
    top_tech.each do |feed|
      puts feed
      Article.update_from_feed(feed, 'top', 'Technology')
    end

    # Business
    puts "Top Business"
    top_business = [
      'http://www.economist.com/rss/finance_and_economics_rss.xml',
      'http://www.ft.com/rss/lex',
      'http://knowledge.wharton.upenn.edu/knowledgefeed.xml',
      'http://www.mckinsey.com/Insights/rss.aspx',
      'http://www.businessweek.com/feeds/homepage.rss'
    ]
    top_business.each do |feed|
      puts feed
      Article.update_from_feed(feed, 'top', 'Business')
    end

    puts "Done."
end

desc "Mail article briefing"
  task :mail_news => :environment do
    @users = User.all
    @users.each do |user|
      UserMailer.mail_news(user).deliver
    end
end