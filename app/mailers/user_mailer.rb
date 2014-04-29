class UserMailer < ActionMailer::Base
  default from: "praefectus@capitalmusings.com"

  def mail_news(user)
    @user = user

    time_range = (Time.now-1.day)..Time.now

    @top_articles = Article.where(published_at: time_range).where(:category => ["top", "cm"]).order("published_at desc")
    @wire_articles = Article.where(published_at: time_range).where(:category => ["wire"]).order("published_at desc")
    
    @top_articles = @top_articles.sort_by!{|article| article.published_at}.reverse!.first(10)
    if @top_articles.class == Article
      @top_articles = [@top_articles]
    end

    @politics_articles = Article.tagged_with("Politics").where(published_at: time_range).order("published_at desc").first(10) unless Tag.find_by_name("Politics").nil?
    @business_articles = Article.tagged_with("Business").where(published_at: time_range).order("published_at desc").first(10) unless Tag.find_by_name("Business").nil?
    @technology_articles = Article.tagged_with("Technology").where(published_at: time_range).order("published_at desc").first(10) unless Tag.find_by_name("Technology").nil?

    if @politics_articles.class == Article
      @politics_articles = [@politics_articles]
    end

    if @business_articles.class == Article
      @business_articles = [@business_articles]
    end

    if @technology_articles.class == Article
      @technology_articles = [@technology_articles]
    end



    @wire_articles = @wire_articles.sort_by!{|article| article.published_at}.reverse!.first(10)


    mail :to => user.email, :subject => "Capital Musings Daily Briefing", :from => "Capital Musings"
  end

end
