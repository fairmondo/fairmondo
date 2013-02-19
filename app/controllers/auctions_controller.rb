# refs https://github.com/dougal/acts_as_indexed/issues/23
require "will_paginate_search"

class AuctionsController < ApplicationController
  autocomplete :auction, :title, :full => true
  # Create is safed by denail!
  before_filter :authenticate_user!, :except => [:show, :index, :autocomplete_auction_title]
 
  before_filter :build_login
  
  before_filter :setup_template_select, :only => [:new]
  
  before_filter :setup_categories, :only => [:index]
   
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
      if @search_cache.categories.present?
        scope = scope.with_categories_or_descendants(@search_cache.categories)
      end
      if params[:auction][:title].present?
        query = params[:auction][:title].gsub(/\b(\w+)\b/) { |w| "^"+w}
        search_params = {:per_page => 12} 
        search_params[:page] = params[:page] || 1
        # we cannot use the relevance search as its pagination does not takes
        # the scopes from before (category, condition) in count
        # @auctions = scope.paginate_search(query, search_params)
        scope = scope.with_query(query) 
      end
    end
    
    @auctions = scope.paginate :page => params[:page], :per_page=>12
 
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
    if current_user.legal_entity && !(@legal_entity_correct = check_legal_entity)
      @error_text =  t('auction.form.missing_terms')
      @missing_terms=( (!current_user.terms||current_user.terms.empty?) ? t('devise.edit_profile.terms') : "" ) +
      ( (!current_user.cancellation||current_user.cancellation.empty?) ? (", "+t('devise.edit_profile.cancellation')) : "" ) +
      ( (!current_user.about||current_user.about.empty?) ? (", "+t('devise.edit_profile.about')) : "" ) 
    end
    
    if template_id = params[:template_select] && params[:template_select][:auction_template]
      if template_id.present?
        @applied_template = AuctionTemplate.find(template_id)
        @auction = Auction.new(@applied_template.deep_auction_attributes)
        flash.now[:notice] = t('template_select.notices.applied', :name => @applied_template.name)
      else
        flash.now[:error] = t('template_select.errors.auction_template_missing')
        @auction = Auction.new
      end
    else
      @auction = Auction.new
    end
    @auction.expire = 14.days.from_now
    @auction.expire = @auction.expire.change(:hour => 17, :minute => 0)
    setup_form_requirements
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @auction }
    end
  end

  # GET /auctions/1/edit
  def edit
    @auction = Auction.with_user_id(current_user.id).find(params[:id])
    setup_form_requirements
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
    if @auction.save && build_and_save_template(@auction)
      
      if @auction.category_proposal.present?
        AuctionMailer.category_proposal(@auction.category_proposal).deliver
      end
      
      @auction.transaction.save! # Should not be a problem!
      respond_created

    else
      respond_to do |format|
        setup_form_requirements
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
      if @auction.update_attributes(params[:auction]) && build_and_save_template(@auction)

        userevent = Userevent.new(:user => current_user, :event_type => UsereventType::AUCTION_UPDATE, :appended_object => @auction)
        userevent.save

        format.html { redirect_to @auction, :notice => (I18n.t 'auction.notices.update') }
        format.json { head :no_content }
      else
        setup_form_requirements
        format.html { render :action => "edit" }
        format.json { render :json => @auction.errors, :status => :unprocessable_entity }
      end
    end
  end

  def report
    @text = params[:report]
    @auction = Auction.find(params[:id])
    if @text != ""
      AuctionMailer.report_auction(@auction,@text).deliver
      redirect_to @auction, :notice => (I18n.t 'auction.actions.reported')
    else
      redirect_to @auction, :notice => (I18n.t 'auction.actions.reported-error')
    end
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
  
  def setup_template_select
    @auction_templates = AuctionTemplate.where(:user_id => current_user.id)
  end
  
  def setup_form_requirements
    setup_categories
    build_questionnaires
    build_template
  end
  
  def build_questionnaires
    @auction.build_fair_trust_questionnaire unless @auction.fair_trust_questionnaire
    @auction.build_social_producer_questionnaire unless @auction.social_producer_questionnaire
  end
  
  def build_template
    unless @auction_template
      if params[:auction_template]
        @auction_template = AuctionTemplate.new(params[:auction_template])
      else
        @auction_template = AuctionTemplate.new
      end
    end
  end
  
  def build_and_save_template(auction)
    if template_attributes = params[:auction_template]
      if template_attributes[:save_as_template] && template_attributes[:name].present? 
        template_attributes[:auction_attributes] = params[:auction]
        @auction_template = AuctionTemplate.new(template_attributes)
        @auction_template.user = auction.seller
        @auction_template.save
      else
        true
      end
    else
      true
    end
  end
  
  def check_legal_entity
      if( !current_user.terms || current_user.terms.empty? ||
          !current_user.cancellation || current_user.cancellation.empty?  ||
          !current_user.about || current_user.about.empty?)
        return false
      end
      return true
  end
  
end
