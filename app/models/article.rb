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
    elsif doc.present? && doc.class == Hash
    # One article
      doc = [doc]
      process(doc, category, tag)
    elsif doc.present?
    # Multple articles
      process(doc, category, tag)
    end
  end

  def next
    self.class.find(
      :first, 
      :conditions => ["category = ? AND published_at > ?", "cm", self.published_at],
      :order => 'published_at')
  end

  def prev
    self.class.find(
      :first, 
      :conditions => ["category = ? AND published_at < ?", "cm", self.published_at],
      :order => 'published_at desc')
  end

  private

    def self.retrieve(feed_url)
      xml_content = feed_url.to_s
      doc = Crack::XML.parse(open(xml_content))
      if doc.present? && doc['rss'].present? && doc['rss']['channel'].present? && doc['rss']['channel']['item'].present?
        doc = doc['rss']['channel']['item']
      elsif doc.present? && doc['rdf:RDF'].present? && doc['rdf:RDF']['item'].present?
        doc = doc['rdf:RDF']['item']
      end
    end

    def self.simplify_url(link)
      link = link.delete("|")
      link = URI.parse(link).host
      link = link.sub(/www./, '').sub(/feedproxy./, '').sub(/feeds./, '').sub(/complex./, '').sub(/blog./, '').sub(/thecable./, '').sub(/southasia./, '') || ""
    end

    def self.simplify_date(date)
      date.localtime.strftime("%A, %-d %B %Y, %-I:%M:%S %P %Z") 
    end

    def self.short_date(date)
      date.localtime.strftime("%-m/%-d/%y") 
    end      

    def self.process(doc, category, tag)
      doc.each do |item|
        if item['link'].length < 256
          # KForce date
          if URI.parse(item['link'].delete("|")).host == "www.kforcegov.com" 
            if item['pubDate'].present? && DateTime.strptime(item['pubDate'].to_s, "%m/%d/%Y %I:%M:%S %p") > 7.days.ago
              unless exists? :guid => item['guid']
                create!(
                  :guid => item['guid'],
                  :name => item['title'],
                  :summary => item['description'],
                  :url => item['link'],
                  :published_at => DateTime.strptime(item['pubDate'], "%m/%d/%Y %I:%M:%S %p"), # This is the different variable
                  :content => item['content:encoded'],
                  :category => category.downcase
                )
                Tagging.create!(
                  :tag_id => Tag.where(name: tag.strip.titleize).first_or_create!.id.to_i,
                  :article_id => Article.last.id.to_i
                )
                puts "'#{item['title']}' saved"
              end
            end
          # Regular structure
          elsif category == 'cm' || item['pubDate'].present? && DateTime.parse(item['pubDate']) > 7.days.ago
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
              puts "'#{item['title']}' saved"
            end
          # Nature's RSS structure
          elsif item['guid'].blank? && item['dc:date'].present? && DateTime.parse(item['dc:date']) > 7.days.ago
            unless exists? :guid => item['link']
              create!(
                :guid => item['link'], # This is the different variable
                :name => item['title'],
                :summary => item['description'],
                :url => item['link'],
                :published_at => item['dc:date'],
                :content => item['content:encoded'],
                :category => category.downcase
              )
              Tagging.create!(
                :tag_id => Tag.where(name: tag.strip.titleize).first_or_create!.id.to_i,
                :article_id => Article.last.id.to_i
              )
              puts "'#{item['title']}' saved"
            end
          end
        end
      end
    end
end