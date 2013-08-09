class PagesController < ApplicationController
  def home
  end

  def about
  end

  def articles
    @articles = FeedEntry.order("published_at desc").page(params[:page]).per_page(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
      format.js
    end

  end
end
