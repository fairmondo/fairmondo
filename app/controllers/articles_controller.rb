class ArticlesController < InheritedResources::Base

  respond_to :html

  # Create is safed by denail!
  before_filter :authenticate_user!, :except => [:show, :index, :autocomplete, :sunspot_failure]

  before_filter :build_login , :unless => :user_signed_in?, :only => [:show,:index, :sunspot_failure]

  before_filter :setup_template_select, :only => [:new]

  before_filter :setup_categories, :build_search_cache, :only => [:index]
  
  before_filter :setup_form_requirements, :only => [:new,:edit,:update,:create]
  
  before_filter :save_images, :only => [:update,:create]

  actions :all, :except => [ :destroy ] # inherited methods

  #Sunspot Autocomplete
  def autocomplete
    search = Sunspot.search(Article) do
      fulltext params[:keywords] do
        fields(:title)
      end
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


  def show
    @article = Article.find(params[:id])
    authorize @article
    if @article.active
      setup_recommendations
    else
      if policy(@article).activate?
      @article.calculate_fees_and_donations
      end
    end
    set_title_image_and_thumbnails

    # find fair alternative
    @alternative = find_fair_alternative_to @article 
    
    show!
  end




  def new
    if !current_user.valid?
      flash[:error] = t('article.notices.incomplete_profile')
      redirect_to edit_user_registration_path
    return
    end
    ############### From Template ################
    if template_id = params[:template_select] && params[:template_select][:article_template]
      if template_id.present?
        @applied_template = ArticleTemplate.find(template_id)
        @article = Article.new(@applied_template.deep_article_attributes, :without_protection => true)
        # Make copies of the images
        @article.images = []
        @applied_template.article.images.each do |image|
          copyimage = Image.new
          copyimage.image = image.image
          @article.images << copyimage
        end
        save_images
        flash.now[:notice] = t('template_select.notices.applied', :name => @applied_template.name)
      else
        flash.now[:error] = t('template_select.errors.article_template_missing')
        @article = Article.new
      end
    else
    #############################################
      @article = Article.new
    end
    @article.seller = current_user
    authorize @article
    setup_form_requirements
    new!

  end

  def edit
    authorize build_resource
    edit!
  end

  def create 
    authorize build_resource
    create!
  end

  def update # Still needs Refactoring

     @article = Article.find(params[:id])
     authorize @article
     if @article.update_attributes(params[:article]) && build_and_save_template(@article)
       respond_to do |format|
          format.html { redirect_to @article, :notice => (I18n.t 'article.notices.update') }
          format.json { head :no_content }
       end
     else
       save_images
       setup_form_requirements
       respond_to do |format|
         format.html { render :action => "edit" }
         format.json { render :json => @article.errors, :status => :unprocessable_entity }
       end
     end

  end

  def activate

      @article = Article.find(params[:id])
      authorize @article
      @article.calculate_fees_and_donations
      @article.locked = true # Lock The Article
      @article.active = true # Activate to be searchable
      @article.save

      update! do |success, failure|
        success.html { redirect_to @article, :notice => I18n.t('article.notices.create') }
        failure.html {
                      setup_form_requirements
                      render :action => :edit
                     }
      end


  end

  def deactivate
      @article = Article.find(params[:id])
      authorize @article
      @article.active = false # Activate to be searchable
      @article.save

      update! do |success, failure|
        success.html {  redirect_to @article, :notice => I18n.t('article.notices.deactivated') }
        failure.html {
                      #should not happen!
                      setup_form_requirements
                      render :action => :edit
                     }
      end
  end

  def report
    @text = params[:report]
    @article = Article.find(params[:id])
    if @text != ""
      ArticleMailer.report_article(@article,@text).deliver
      redirect_to @article, :notice => (I18n.t 'article.actions.reported')
    else
      redirect_to @article, :notice => (I18n.t 'article.actions.reported-error')
    end
  end


  ##### Private Helpers


  private
  
  def build_search_cache
     @search_cache = Article.new(params[:article])
  end

  def search_for query
    ######## Solr
      search = Article.search do
        fulltext query.title
        paginate :page => params[:page], :per_page=>12
        with :fair, true if query.fair
        with :ecologic, true if query.ecologic
        with :small_and_precious, true if query.small_and_precious
        with :condition, query.condition if query.condition
        with :category_ids, Article::Categories.search_categories(query.categories) if query.categories.present?
      end
      return search.results
    ########
  rescue Errno::ECONNREFUSED
      render_hero :action => "sunspot_failure"
      return policy_scope(Article).paginate :page => params[:page], :per_page=>12
  end

  def find_fair_alternative_to article
    search = Article.search do
      fulltext article.title do
        boost(3.0) { with(:fair, true) }
        boost(2.0) { with(:ecologic, true) }
        boost(1.0) { with(:condition, :old) }
      end
      any_of do
        with :fair,true
        with :ecologic,true
        with :condition, :old
      end
    end
    return search.results.first 
  rescue Errno::ECONNREFUSED  
   return nil
  end

 
  def setup_template_select
    @article_templates = ArticleTemplate.where(:user_id => current_user.id)
  end

  def setup_recommendations
    @libraries = @article.libraries.public.paginate(:page => params[:page], :per_page=>10)
    @seller_products = @article.seller.articles.paginate(:page => params[:page], :per_page=>18)
  end

  def set_title_image_and_thumbnails
    if params[:image]
      @title_image = Image.find(params[:image])
    else
      @title_image = @article.images[0]
    end
    @thumbnails = @article.images
    @thumbnails.reject!{|image| image.id == @title_image.id} if @title_image #Reject the selected image from
  end

  ################## Form #####################
  def setup_form_requirements
    resource ||= build_resource
    setup_transaction
    setup_categories
    build_questionnaires
    build_template
  end

  def setup_transaction
    resource.build_transaction
  end

  def build_questionnaires
    resource.build_fair_trust_questionnaire unless resource.fair_trust_questionnaire
    resource.build_social_producer_questionnaire unless resource.social_producer_questionnaire
  end

  def build_template
    resource.build_article_template unless resource.article_template
  end


  

  ############ Save Images ################

  def save_images
    #At least try to save the images -> not persisted in browser
    resource.images.each do |image|
        image.save
     end
  end

  ################## Inherited Resources
  protected

  def collection
    @articles ||= search_for @search_cache
  end

end

