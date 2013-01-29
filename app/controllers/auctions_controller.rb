# refs https://github.com/dougal/acts_as_indexed/issues/23
require "will_paginate_search"

class AuctionsController < ApplicationController
  autocomplete :auction, :title, :full => true
  # Create is safed by denail!
  before_filter :authenticate_user!, :except => [:show, :index, :autocomplete_auction_title]
 
  before_filter :build_login
  
  before_filter :setup_categories, :only => [:index, :new, :edit]
   
  # GET /auctions
  # GET /auctions.json
  # GET /auctions.csv
  def index
    @search_cache = Auction.new(params[:auction])
    scope = Auction.with_user_id
    
    if params[:auction]
      if params[:auction][:condition].present?  
        scope = scope.where(:condition => params[:auction][:condition])
      end
      if params[:auction][:categories_with_parents].present?  
        scope = scope.with_categories(params[:auction][:categories_with_parents])
      end
      if params[:auction][:title].present?  
        query = params[:auction][:title].gsub(/\b(\w+)\b/) { |w| "^"+w}
        search_params = {:per_page => 12} 
        search_params[:page] = params[:page] || 1
        # we cannot use the relevance search, see TODO
        # @auctions = scope.paginate_search(query, search_params)
        scope = scope.with_query(query) 
      end      
      @auctions = scope.paginate :page => params[:page], :per_page=>12
    else
      @auctions = scope.paginate :page => params[:page], :per_page=>12
    end
 
    respond_to do |format|
      format.html # index.html.erb
      format.csv { render text: @auctions.to_csv }
      format.json { render :json => @auctions }
    end
  end

  # GET /auctions/1
  # GET /auctions/1.json
  def show
    @auction = Auction.find(params[:id])
    if @auction.seller == current_user
      @image = Image.new
      @image.auction = @auction
    end
    if params[:image]
      @title_image = Image.find(params[:image])
    else
      @title_image = @auction.title_image
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @auction }
    end
  end

  # GET /auctions/new
  # GET /auctions/new.json
  def new
    @auction = Auction.new
    @auction.expire = 14.days.from_now
    @auction.expire = @auction.expire.change(:hour => 17, :minute => 0)
    build_questionnaires
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @auction }
    end
  end

  # GET /auctions/1/edit
  def edit
    @auction = Auction.with_user_id(current_user.id).find(params[:id])
    build_questionnaires
    respond_to do |format|
      format.html 
      format.json { render :json => @auction }
    end
  end

  # POST /auctions
  # POST /auctions.json
  def create
    @auction = Auction.new(params[:auction])
    
    @auction.seller = current_user
   
    # Check if we can save the auction
    if @auction.save
      
      if @auction.category_proposal.present?
        AuctionMailer.category_proposal(@auction.category_proposal).deliver
      end
      
      @auction.transaction.save! # Should not be a problem!
      respond_created

    else
      respond_to do |format|
        setup_categories
        build_questionnaires
        format.html { render :action => "new" }
        format.json { render :json => @auction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /auctions/1
  # PUT /auctions/1.json
  def update
    @auction = Auction.with_user_id(current_user.id).find(params[:id])

    respond_to do |format|
      if @auction.update_attributes(params[:auction])

        userevent = Userevent.new(:user => current_user, :event_type => UsereventType::AUCTION_UPDATE, :appended_object => @auction)
        userevent.save

        format.html { redirect_to @auction, :notice => (I18n.t 'auction.notices.update') }
        format.json { head :no_content }
      else
        setup_categories
        build_questionnaires
        format.html { render :action => "edit" }
        format.json { render :json => @auction.errors, :status => :unprocessable_entity }
      end
    end
  end

  def report
    @auction = Auction.find(params[:id])
    AuctionMailer.report_auction(@auction).deliver
    redirect_to @auction, :notice => (I18n.t 'auction.actions.reported')
  end

  def setup_categories
    @categories = Category.roots
  end
  
  def follow
    @product = Auction.find params["id"]
    current_user.follow(@product)
    Userevent.new(:user => current_user, :event_type => UsereventType::PRODUCT_FOLLOW, :appended_object => @product).save

    respond_to do |format|
      format.html { redirect_to auction_path(:id => @product.id) , :notice => (I18n.t 'user.follow.following') }
      format.json { head :no_content }
    end
  end
  
  def stop_follow
    @product = Auction.find params["id"]
    current_user.stop_following(@product) # Deletes that record in the Follow table
    
    respond_to do |format|
      format.html { redirect_to auction_path(:id => @product.id) , :notice => (I18n.t 'user.follow.stop_following') }
      format.json { head :no_content }
    end
  end

  private
     
  def respond_created
     #Throwing User Events
      Userevent.new(:user => current_user, :event_type => UsereventType::AUCTION_CREATE, :appended_object => @auction).save
      respond_to do |format|
        format.html { redirect_to @auction, :notice => I18n.t('auction.notices.create') }
        format.json { render :json => @auction, :status => :created, :location => @auction }
      end
  end
  
  def build_questionnaires
    @auction.build_fair_trust_questionnaire unless @auction.fair_trust_questionnaire
    @auction.build_social_producer_questionnaire unless @auction.social_producer_questionnaire
  end
  
  def update_category_ids
    if params[:add_category_id]
      @auction.category_ids << params[:add_category_id].to_i
    elsif params[:remove_category_id]
      @auction.category_ids.delete(params[:remove_category_id].to_i)
    else
      false
    end
  end
    
    
end
