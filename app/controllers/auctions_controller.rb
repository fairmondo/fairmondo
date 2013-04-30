class AuctionsController < InheritedResources::Base

  respond_to :html

  # Create is safed by denail!
  before_filter :authenticate_user!, :except => [:show, :index, :autocomplete, :sunspot_failure]

  before_filter :build_login , :unless => :user_signed_in?, :only => [:show,:index, :sunspot_failure]

  before_filter :setup_template_select, :only => [:new]

  before_filter :setup_categories, :only => [:index]

  actions :all, :except => [ :create, :destroy ] # inherited methods
  
  #Sunspot Autocomplete
  def autocomplete
    search = Sunspot.search(Auction) do
      fulltext params[:keywords] do
        fields(:title)
      end
      with :active, true
    end
    @titles = []
    search.hits.each do |hit|
      title = hit.stored(:title).first
      @titles.push(title)
    end
    render :json => @titles
  rescue Errno::ECONNREFUSED
    render :json => []
    end

  def index
    @search_cache = Auction.new(params[:auction])

    ######## Solr
    begin
      query = @search_cache
      search = Sunspot.search(Auction) do
        fulltext query.title
        paginate :page => params[:page], :per_page=>12
        with :fair, true if query.fair
        with :ecologic, true if query.ecologic
        with :small_and_precious, true if query.small_and_precious
        with :condition, query.condition if query.condition
        with :category_ids, Auction::Categories.search_categories(query.categories) if query.categories.present?
      end
      @auctions = search.results
      ########
    rescue Errno::ECONNREFUSED
     @auctions = policy_scope(Auction).paginate :page => params[:page], :per_page=>12
     render_hero :action => "sunspot_failure"
    end
    
    index!
  end

 

  def show
    @auction = Auction.find(params[:id])
    authorize @auction
    if @auction.active
      setup_recommendations
    else
      if policy(@auction).activate?
      @auction.calculate_fees_and_donations
      end
    end
    set_title_image_and_thumbnails
    show!
  end

  def new
    if !current_user.valid?
      flash[:error] = t('auction.notices.incomplete_profile')
      redirect_to edit_user_registration_path
    return
    end
    ############### From Template ################
    if template_id = params[:template_select] && params[:template_select][:auction_template]
      if template_id.present?
        @applied_template = AuctionTemplate.find(template_id)
        @auction = Auction.new(@applied_template.deep_auction_attributes, :without_protection => true)
        # Make copies of the images
        @auction.images = []
        @applied_template.auction.images.each do |image|
          copyimage = Image.new
          copyimage.image = image.image
          @auction.images << copyimage
        end
        save_images
        flash.now[:notice] = t('template_select.notices.applied', :name => @applied_template.name)
      else
        flash.now[:error] = t('template_select.errors.auction_template_missing')
        @auction = Auction.new
      end
    else
    #############################################
      @auction = Auction.new
    end

    authorize @auction
    setup_form_requirements
    new!

  end

  def edit

    @auction = Auction.find(params[:id])
    authorize @auction
    setup_form_requirements
    edit!
  end

  def create # Still needs Refactoring

    @auction = Auction.new(params[:auction])

    @auction.seller = current_user

    authorize @auction

    # Check if we can save the auction
 
    if @auction.save && build_and_save_template(@auction)

      if @auction.category_proposal.present?
        AuctionMailer.category_proposal(@auction.category_proposal).deliver
      end

      respond_to do |format|
        format.html { redirect_to auction_path(@auction) }
        format.json { render :json => @auction, :status => :created, :location => @auction }
      end

    else
      save_images
      respond_to do |format|
        setup_form_requirements
        format.html { render :action => "new" }
        format.json { render :json => @auction.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update # Still needs Refactoring
    
     @auction = Auction.find(params[:id])
     authorize @auction
     if @auction.update_attributes(params[:auction]) && build_and_save_template(@auction)
       respond_to do |format|
          format.html { redirect_to @auction, :notice => (I18n.t 'auction.notices.update') }
          format.json { head :no_content }
       end
     else
       save_images
       setup_form_requirements
       respond_to do |format|
         format.html { render :action => "edit" }
         format.json { render :json => @auction.errors, :status => :unprocessable_entity }
       end
     end
    
  end
  
  def activate
    
      @auction = Auction.find(params[:id])
      authorize @auction
      @auction.calculate_fees_and_donations
      @auction.locked = true # Lock The Auction
      @auction.active = true # Activate to be searchable
      @auction.save
      
      update! do |success, failure|
        success.html { redirect_to @auction, :notice => I18n.t('auction.notices.create') }
        failure.html { 
                      setup_form_requirements
                      render :action => :edit 
                     }
      end
     
    
  end
  
  def deactivate
      @auction = Auction.find(params[:id])
      authorize @auction
      @auction.active = false # Activate to be searchable
      @auction.save
      
      update! do |success, failure|
        success.html {  redirect_to @auction, :notice => I18n.t('auction.notices.deactivated') }
        failure.html { 
                      #should not happen!
                      setup_form_requirements
                      render :action => :edit 
                     }
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
  
  
  ##### Private Helpers
  

  private

  def setup_template_select
    @auction_templates = AuctionTemplate.where(:user_id => current_user.id)
  end

  def setup_recommendations
    @libraries = @auction.libraries.public.paginate(:page => params[:page], :per_page=>10)
    @seller_products = @auction.seller.auctions.paginate(:page => params[:page], :per_page=>18)
  end

  def set_title_image_and_thumbnails
    if params[:image]
      @title_image = Image.find(params[:image])
    else
      @title_image = @auction.images[0]
    end
    @thumbnails = @auction.images
    @thumbnails.reject!{|image| image.id == @title_image.id} if @title_image #Reject the selected image from
  end

  ################## Form #####################
  def setup_form_requirements
    setup_transaction
    setup_categories
    build_questionnaires
    build_template
  end

  def setup_transaction
    @auction.build_transaction
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


  ########## build Template #################
  def build_and_save_template(auction)
    if template_attributes = params[:auction_template]
      if template_attributes[:save_as_template] && template_attributes[:name].present?
        template_attributes[:auction_attributes] = params[:auction]
        @auction_template = AuctionTemplate.new(template_attributes)
        @auction_template.auction.images.clear
        auction.images.each do |image|
          copyimage = Image.new
          copyimage.image = image.image
          @auction_template.auction.images << copyimage
          copyimage.save
        end

      @auction_template.user = auction.seller
      @auction_template.save
      else
      true
      end
    else
    true
    end
  end

  ############ Save Images ################

  def save_images
    #At least try to save the images -> not persisted in browser
    if @auction
      @auction.images.each do |image|
        image.save
      end
    end
  end

  ################## Inherited Resources 
  protected

  def collection
    @libraries ||= policy_scope(Auction)
  end

end

