class UserMailer < ActionMailer::Base
  default from: "praefectus@capitalmusings.com"

  def mail_news(user)
    @user = user

    @top_articles = Article.where("published_at > :one_day_ago", :one_day_ago => 1.day.ago).where(:category => ["top", "cm"]).order("published_at desc")
    @wire_articles = Article.where("published_at > :one_day_ago", :one_day_ago => 1.day.ago).where(:category => ["wire"]).order("published_at desc")
    
    @top_articles = @top_articles.sort_by!{|article| article.published_at}.reverse!
    @wire_articles = @wire_articles.sort_by!{|article| article.published_at}.reverse!.first(10)

    mail :to => user.email, :subject => "Capital Musings Daily Briefing", :from => "Capital Musings"
  end

end
