class AuctionsController < ApplicationController
  # GET /auctions
  # GET /auctions.json
  def index
    @auctions = Auction.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @auctions }
    end
  end

  # GET /auctions/1
  # GET /auctions/1.json
  def show
    @auction = Auction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @auction }
    end
  end

  # GET /auctions/new
  # GET /auctions/new.json
  def new
    user_signed_in?
    @categories = Category.find(:all, :conditions => "level=0", :order => "name")
    @auction = Auction.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @auction }
    end
  end

  # GET /auctions/1/edit
  def edit
    user_signed_in?
    @auction = Auction.find(params[:id])
  end

  # POST /auctions
  # POST /auctions.json
  def create
    user_signed_in?
    params.each do |key, value|
      if (key.to_s.start_with? 'category')
      @category_str=key.to_s
      end
    end
    if defined? @category_str # Category changes found
      @category_id = @category_str.slice(8..-1).to_i

      # Handle Changing Categories

      @categories = Category.find(:all, :conditions => "level=0", :order => "name")
      @selected_category = Category.find @category_id

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

      @auction = Auction.new(params[:auction])
      
      render :action => 'new'
      
    else
      
      # Handle Commits
   
      @auction = Auction.new(params[:auction])
      @auction.category=Category.find params[:selected_category].to_i
     
      case @auction.category.level 
      when 0 then nil
      when 1 then @auction.alt_category_1 = @auction.category.parent
      when 2 then 
        @auction.alt_category_1 = @auction.category.parent
        @auction.alt_category_2 = @auction.category.parent.parent
      end
      @auction.seller= current_user
      respond_to do |format|
        if @auction.save
          format.html { redirect_to @auction, :notice => I18n.t('auction.notices.create') }
          format.json { render :json => @auction, :status => :created, :location => @auction }
        else
          format.html { render :action => "new" }
          format.json { render :json => @auction.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /auctions/1
  # PUT /auctions/1.json
  def update
    user_signed_in?
    @auction = Auction.find(params[:id])

    respond_to do |format|
      if @auction.update_attributes(params[:auction])
        format.html { redirect_to @auction, :notice => (I18n.t 'auction.notices.update') }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @auction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /auctions/1
  # DELETE /auctions/1.json
  def destroy
    user_signed_in?
    @auction = Auction.find(params[:id])
    @auction.destroy

    respond_to do |format|
      format.html { redirect_to auctions_url }
      format.json { head :no_content }
    end
  end
end
