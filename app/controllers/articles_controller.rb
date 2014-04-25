class ArticlesController < ApplicationController
  # Categories are stored in downcase in the database

before_filter :authenticate_admin!, only: :edit

  def musings
    @articles = Article.where(:category => ["cm"]) # Filter Category
    @articles = @articles.where("published_at <= :time_now", {time_now: Time.now}) # Remove invalid published_at dates
    @articles = @articles.order("published_at desc").page(params[:page])
    if mobile_device?
      @articles = @articles.per_page(10) # For will_paginate
    else
      @articles = @articles.per_page(10)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
      format.js
    end
  end

  def top
    @articles = Article.where(:category => ["top", "cm"]) # Filter Category
    @articles = @articles.where("published_at <= :time_now", {time_now: Time.now}) # Remove invalid published_at dates
    @articles = @articles.order("published_at desc").page(params[:page]).per_page(10) # For will_paginate

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
      format.js
    end
  end

  def wires
    @articles = Article.where("category = ?", "wire")
    @articles = @articles.where("published_at <= :time_now", {time_now: Time.now}) # Remove invalid published_at dates
    @articles = @articles.order("published_at desc").page(params[:page]).per_page(25) # For will_paginate

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
      format.js
    end
  end

  def index
    if params[:tag]
      @articles = Article.tagged_with(params[:tag]) # Select Articles that are tagged
      @articles = @articles.where("published_at <= :time_now", {time_now: Time.now}) # Remove invalid published_at dates
      @articles = @articles.order("published_at desc").page(params[:page]).per_page(10) # For will_paginate
      @first_article = @articles.first

    else
      @articles = Article.where("published_at <= :time_now", {time_now: Time.now}) # Remove invalid published_at dates
      @articles = @articles.order("published_at desc").page(params[:page]).per_page(10) # For will_paginate
      @first_article = @articles.first
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
      format.js
    end
  end

  def edit
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @article }
      format.js
    end
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)


    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render action: 'show', status: :created, location: @article }
      else
        format.html { render action: 'new' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    @article = Article.find(params[:id])
    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to articles_url, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end

  def show
    @article = Article.find(params[:id])
  end



end
