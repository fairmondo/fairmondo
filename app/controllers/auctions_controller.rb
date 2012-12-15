# refs https://github.com/dougal/acts_as_indexed/issues/23
require "will_paginate_search"

class AuctionsController < ApplicationController
  autocomplete :auction, :title, :full => true
  # Create is safed by denail!
  before_filter :authenticate_user!, :except => [:show, :index,:new, :create, :autocomplete_auction_title]
 
  before_filter :build_login
 
  # GET /auctions
  # GET /auctions.json
  # GET /auctions.csv
  def index
    scope = Auction.with_user_id
    scope = scope.with_category(params["selected_category_id"])
    if params["q"] && !params["q"].blank?
      # refs #108 
      query = params["q"].gsub(/\b(\w+)\b/) { |w| "^"+w}
      search_params = {:per_page => 12} 
      search_params[:page] = params[:page] || 1
      @auctions = scope.paginate_search(query, search_params)
    else
      @auctions = scope.paginate :page => params[:page], :per_page=>12
    end
 
    setup_categories params["selected_category_id"]
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
    # We want a new object so we dont need the old one anymore
    clear_stored_object
    setup_categories
    @auction = Auction.new
    @auction.expire = 14.days.from_now
    @auction.expire = @auction.expire.change(:hour => 17, :minute => 0)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @auction }
    end
  end

  # GET /auctions/1/edit
  def edit
    @auction = Auction.find(params[:id])
    setup_categories @auction.category.id
  end

  def finalize
    if user_signed_in? && get_stored_object
      @auction = Auction.find(get_stored_object)
      @auction.seller = current_user
      #We dont need the validation since we want to update the seller
      if(@auction.save :validate => false) 
        #Remove any stored object
        clear_stored_object
        respond_created
      end
      
    end
     
  end

  # POST /auctions
  # POST /auctions.json
  def create

    if selected_category? # Category changes found
      @auction = Auction.new(params[:auction])
      render :action => 'new'
      return
    end
    
    @auction = Auction.new(params[:auction])
    set_category
  
    if user_signed_in?
      @auction.seller = current_user
    end
    
   
    
    # Check if we can save the auction
    if @auction.save
      
      if !@auction.category_proposal.empty?
        AuctionMailer.category_proposal(@auction.category_proposal).deliver
      end
      
      @auction.transaction.save! # Should not be a problem!
      # If the User isnt singned in save auction number in the session
      if !user_signed_in?
        deny_access_to_save_object @auction.id , "/continue_creating_auction"
      else
        respond_created
      end

    else
      respond_to do |format|
        setup_categories @auction.category
        format.html { render :action => "new" }
        format.json { render :json => @auction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /auctions/1
  # PUT /auctions/1.json
  def update
    @auction = Auction.find(params[:id])

    if selected_category? # Category changes found
      render :action => 'edit'
    else
      set_category
      respond_to do |format|
        if @auction.update_attributes(params[:auction])

          userevent = Userevent.new(:user => current_user, :event_type => UsereventType::AUCTION_UPDATE, :appended_object => @auction)
          userevent.save

          format.html { redirect_to @auction, :notice => (I18n.t 'auction.notices.update') }
          format.json { head :no_content }
        else
          setup_categories @auction.category
          format.html { render :action => "edit" }
          format.json { render :json => @auction.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def report
    @auction = Auction.find(params[:id])
    AuctionMailer.report_auction(@auction).deliver
    redirect_to @auction, :notice => (I18n.t 'auction.actions.reported')
  end


  def selected_category?
     params.each do |key, value|
      if (key.to_s.start_with? 'category')
      @category_str=key.to_s
      end
     end
     if defined? @category_str # Category changes found
        @category_id = @category_str.slice(8..-1).to_i
        setup_categories @category_id
        return true
     end
     return false
  end

  def setup_categories category_id=nil
    # Handle Changing Categories
    if !category_id
      @categories = Category.find(:all, :conditions => "level=0", :order => "name")
    else
      @categories = Category.find(:all, :conditions => "level=0", :order => "name")
      @selected_category = Category.find category_id

      @active_category = case @selected_category.level
      when 0 then @selected_category
      when 1 then @selected_category.parent
      when 2 then @selected_category.parent.parent
      end

      @active_subcategory = case @selected_category.level
      when 0 then nil
      when 1 then @selected_category
      when 2 then @selected_category.parent
      end

      @active_subsubcategory = case @selected_category.level
      when 0 then nil
      when 1 then nil
      when 2 then @selected_category
      end

      @subcategories = Category.find(:all, :conditions =>  [ "parent_id = ?", @active_category.id], :order => "name")
      if @active_subcategory
        @subsubcategories = Category.find(:all, :conditions =>  [ "parent_id = ?",  @active_subcategory], :order => "name")
      end
    end
  end

  def set_category(category_id = nil)

    if params.has_key? :selected_category
      category_id = params[:selected_category].to_i
    end
    if category_id && category_id!=0
      @auction.category=Category.find category_id

      case @auction.category.level
      when 0 then nil
      when 1 then @auction.alt_category_1 = @auction.category.parent
      when 2 then
        @auction.alt_category_1 = @auction.category.parent
        @auction.alt_category_2 = @auction.category.parent.parent
      end

    else
    @no_category_error=true
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

  def respond_created
     #Throwing User Events
      Userevent.new(:user => current_user, :event_type => UsereventType::AUCTION_CREATE, :appended_object => @auction).save
      respond_to do |format|
        format.html { redirect_to @auction, :notice => I18n.t('auction.notices.create') }
        format.json { render :json => @auction, :status => :created, :location => @auction }
      end
  end
end
