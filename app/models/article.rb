class Article < ActiveRecord::Base
  attr_accessible :guid, :name, :published_at, :summary, :url, :category, :content

  require 'open-uri'

  def self.update_from_feed(feed_url, category = 'uncategorized')
    doc = retrieve(feed_url)


  # The differing levels of indentation would break this method.
  # Therefore, inserted some flow control.
  # If it's an array, need to call the each method to go through each parameter.
  # But if it's a hash, you need to run through the parameters directly.

    if doc.class == Array
      doc.each do |item|
        unless exists? :guid => item['guid']
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
    elsif doc.class == Hash
      unless exists? :guid => doc['guid']
      create!(
        :guid => doc['guid'],
        :name => doc['title'],
        :summary => doc['description'],
        :url => doc['link'],
        :published_at => doc['pubDate'],
        :content => doc['content:encoded'],
        :category => category.downcase
      )
      end
    else
    end


  end

  private

  def self.retrieve(feed_url)
    xml_content = feed_url.to_s
    doc = Crack::XML.parse(open(xml_content))['rss']['channel']['item']
  end


end