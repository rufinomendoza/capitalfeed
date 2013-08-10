class NewsController < ApplicationController

  # Categories are stored in downcase in the database

  def home
    @articles = FeedEntry.where("category = ?", "cm").order("published_at desc").page(params[:page]).per_page(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
      format.js
    end
  end

  def top
    @articles = FeedEntry.where(:category => ["top", "cm"]).order("published_at desc").page(params[:page]).per_page(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
      format.js
    end
  end

  def wires
    @articles = FeedEntry.where("category = ?", "wire").order("published_at desc").page(params[:page]).per_page(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
      format.js
    end
  end
end
