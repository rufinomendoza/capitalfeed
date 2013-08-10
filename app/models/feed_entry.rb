class FeedEntry < ActiveRecord::Base
  attr_accessible :guid, :name, :published_at, :summary, :url, :category, :content

  require 'open-uri'

  def self.update_from_feed(feed_url, category = 'uncategorized')
    doc = retrieve(feed_url)
    if doc
      doc.each do |item|
        if item
          unless exists? :guid => item['guid']
            if
              create!(
                :guid => item['guid'],
                :name => item['title'],
                :summary => item['description'],
                :url => item['link'],
                :published_at => item['pubDate'],
                :content => item['content:encoded'],
                :category => category.downcase
              )
            end
          end
        end
      end
    end
  end

  private

  def self.retrieve(feed_url)
    xml_content = feed_url.to_s
    doc = Crack::XML.parse(open(xml_content))['rss']['channel']['item']
  end

end