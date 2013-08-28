class UserMailer < ActionMailer::Base
  default from: "praefectus@capitalmusings.com"

  def mail_news(user)
    @user = user

    @top_articles = FeedEntry.where("published_at > :one_day_ago", :one_day_ago => 1.day.ago).where(:category => ["top", "cm"]).order("published_at desc")
    @wire_articles = FeedEntry.where("published_at > :one_day_ago", :one_day_ago => 1.day.ago).where(:category => ["wire"]).order("published_at desc")

    mail :to => user.email, :subject => "Capital Musings Daily Briefing"
  end

end
