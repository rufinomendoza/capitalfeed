class FeedEntry < ActiveRecord::Base
  attr_accessible :guid, :name, :published_at, :summary, :url

  def self.update_from_feed(feed_url)
    xml_content = feed_url.to_s
    doc = Nokogiri::XML(open(xml_content))
    feed = SimpleRSS.parse(doc)

    feed.items.each do |item|
      unless exists? :guid => item.guid
        create!(
          :guid => item.guid,
          :name => item.title,
          :summary => item.description,
          :url => item.link,
          :published_at => item.pubDate
        )
      end
    end
  end

end