class Article < ActiveRecord::Base
  attr_accessible :guid, :name, :published_at, :summary, :url, :category, :content, :tag_list
  validates_presence_of :published_at

  has_many :taggings
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
        Tagging.create!(
          :tag_id => Tag.where(name: tag.strip.titleize).first_or_create!.id.to_i,
          :article_id => Article.last.id.to_i
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
      Tagging.create!(
        :tag_id => Tag.where(name: tag.strip.titleize).first_or_create!.id.to_i,
        :article_id => Article.last.id.to_i
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