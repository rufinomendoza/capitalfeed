class Article < ActiveRecord::Base
  attr_accessible :guid, :name, :published_at, :summary, :url, :category, :content, :tag_list
  # validates_presence_of :published_at

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings



  require 'open-uri'

  def self.tagged_with(name)
    Tag.find_by_name!(name).articles
  end

  def self.tag_counts
    Tag.select("tags.id, tags.name").
      joins(:taggings).group("tags.id, tags.name")
  end
  
  def tag_list
    tags.map(&:name).join(", ")
  end
  
  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end




  def self.update_from_feed(feed_url, category = 'uncategorized', tag = '')
    doc = retrieve(feed_url)

    if doc.blank?
    # No articles 
      puts "No updates at this time"
    end
    
    if doc.present? && doc.class == Hash
    # One article
      doc = [doc]
    elsif doc.present?
    # Multple articles
      doc.each do |item|
        unless exists? :guid => item['guid']
          if item['link'].length < 256 and item['pubDate'].present? and DateTime.parse(item['pubDate']) > 7.days.ago
            create!(
              :guid => item['guid'],
              :name => item['title'],
              :summary => item['description'],
              :url => item['link'],
              :published_at => item['pubDate'],
              :content => item['content:encoded'],
              :category => category.downcase
            )
            Tagging.create!(
              :tag_id => Tag.where(name: tag.strip.titleize).first_or_create!.id.to_i,
              :article_id => Article.last.id.to_i
            )
            puts item.name
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

    def self.simplify_url(link)
      link = link.delete("|")
      link = URI.parse(link).host
      link = link.sub(/www./, '').sub(/feedproxy./, '').sub(/feeds./, '') || ""
    end

    def self.simplify_date(date)
      date.localtime.strftime("%A, %-d %B %Y, %-I:%M:%S %P %Z") 
    end


end