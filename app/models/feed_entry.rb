class FeedEntry < ActiveRecord::Base
  attr_accessible :guid, :name, :published_at, :summary, :url

  require 'open-uri'

  def self.update_from_feed(feed_url)
    xml_content = feed_url.to_s
    
    doc = Crack::XML.parse(open(xml_content))['rss']['channel']['item']

    doc.each do |item|
      unless exists? :guid => item['guid']
        create!(
          :guid => item['guid'],
          :name => item['title'],
          :summary => item['description'],
          :url => item['link'],
          :published_at => item['pubDate']
        )
      end
    end
  end

end