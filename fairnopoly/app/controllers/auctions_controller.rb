class AuctionsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show, :index,:new, :create] 
  
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
    setup_categories nil
    @auction = Auction.new
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

  # POST /auctions
  # POST /auctions.json
  def create
    
    params.each do |key, value|
      if (key.to_s.start_with? 'category')
      @category_str=key.to_s
      end
    end
    if defined? @category_str # Category changes found
      @category_id = @category_str.slice(8..-1).to_i

      setup_categories @category_id

      @auction = Auction.new(params[:auction])
      
      render :action => 'new'
      
    else
      @auction = Auction.new(params[:auction])
      if !user_signed_in?
        hash = { "auction" => params[:auction] , "selected_category" => params[:selected_category]}
         
        deny_access_to_save_object YAML::dump(hash) , "/continue_creating_auction" 
      else
       
        if get_stored_object
          hash = YAML::load(get_stored_object)
          @auction = Auction.new(hash["auction"])
           # Set the Categories from the ID
          set_category hash["selected_category"].to_i
          clear_stored_object
        else
          @auction = Auction.new(params[:auction])
          # Set the Categories from the ID
          set_category
        end

        respond_to do |format|
          if @auction.save
            format.html { redirect_to @auction, :notice => I18n.t('auction.notices.create') }
            format.json { render :json => @auction, :status => :created, :location => @auction }
          else
            setup_categories @auction.category
            format.html { render :action => "new" }
            format.json { render :json => @auction.errors, :status => :unprocessable_entity }
          end
        end
       end
    end
  end

  # PUT /auctions/1
  # PUT /auctions/1.json
  def update
    @auction = Auction.find(params[:id])
   
     params.each do |key, value|
      if (key.to_s.start_with? 'category')
      @category_str=key.to_s
      end
    end
    if defined? @category_str # Category changes found
      @category_id = @category_str.slice(8..-1).to_i

      setup_categories @category_id

      render :action => 'edit'
    else
      set_category
      respond_to do |format|
        if @auction.update_attributes(params[:auction])
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
  
  
  def setup_categories category_id
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
        @auction.seller= current_user
     else
       @no_category_error=true
     end
 
  end
  
end
