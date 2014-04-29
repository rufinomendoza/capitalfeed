class UserMailer < ActionMailer::Base
  default from: "praefectus@capitalmusings.com"

  def mail_news(user)
    @user = user

    time_range = (Time.now-1.day)..Time.now

    # Database lookup
    @politics_articles = Article.tagged_with("Politics").where(published_at: time_range).order("published_at desc") unless Tag.find_by_name("Politics").nil?
    @business_articles = Article.tagged_with("Business").where(published_at: time_range).order("published_at desc") unless Tag.find_by_name("Business").nil?
    @technology_articles = Article.tagged_with("Technology").where(published_at: time_range).order("published_at desc") unless Tag.find_by_name("Technology").nil?

    # If only one article, make sure it is an array
    if @politics_articles.class == Article
      @politics_articles = [@politics_articles]
    end

    if @business_articles.class == Article
      @business_articles = [@business_articles]
    end

    if @technology_articles.class == Article
      @technology_articles = [@technology_articles]
    end

    # Making sure they are properly arranged in reverse chronology
    @politics_articles = @politics_articles.sort_by!{|article| article.published_at}.reverse!.first(10)
    @business_articles = @business_articles.sort_by!{|article| article.published_at}.reverse!.first(10)
    @technology_articles = @technology_articles.sort_by!{|article| article.published_at}.reverse!.first(10)

    # Currently disabled
    # @top_articles = Article.where(published_at: time_range).where(:category => ["top", "cm"]).order("published_at desc")
    # @wire_articles = Article.where(published_at: time_range).where(:category => ["wire"]).order("published_at desc")

    # if @top_articles.class == Article
    #   @top_articles = [@top_articles]
    # end
    # if @wire_articles.class == Article
    #   @wire_articles = [@wire_articles]
    # end
    
    # @top_articles = @top_articles.sort_by!{|article| article.published_at}.reverse!.first(10)
    # @wire_articles = @wire_articles.sort_by!{|article| article.published_at}.reverse!.first(10)

    mail :to => user.email, :subject => "Capital Musings Daily Briefing", :from => "Capital Musings"
  end

end
