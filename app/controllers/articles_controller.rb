class ArticlesController < InheritedResources::Base

  # Inherited Resources

  respond_to :html

  actions :all, :except => [ :destroy ] # inherited methods

  # Authorization
  before_filter :authenticate_user!, :except => [:show, :index, :autocomplete, :sunspot_failure]

  # Layout Requirements

  before_filter :build_login , :unless => :user_signed_in?, :only => [:show,:index, :sunspot_failure]

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
    @article = Article.find params[:id]
    authorize resource

    if !resource.active && policy(resource).activate?
      resource.calculate_fees_and_donations
    end

    show!
  end

  def new
    if !current_user.valid?
      flash[:error] = t('article.notices.incomplete_profile')
      redirect_to edit_user_registration_path
      return
    end
    ############### From Template ################
    if template_id = (params[:template_select] && params[:template_select][:article_template])
      @applied_template = ArticleTemplate.find(template_id)
      @article = @applied_template.article.amoeba_dup
      flash.now[:notice] = t('template_select.notices.applied', :name => @applied_template.name)
    end
    build_resource
    authorize resource_with_dependencies
    new!
  end

  def edit
    authorize resource_with_dependencies
    edit!
  end

  def create

    authorize build_resource

    create! do |success, failure|
      success.html { redirect_to resource }
      failure.html { save_images
                     resource_with_dependencies
                     render :new }
    end
  end

  def update # Still needs Refactoring
    authorize resource
    update! do |success, failure|
      success.html { redirect_to @article }
      failure.html { resource_with_dependencies
                     save_images
                     render :edit }
    end
  end

  def activate
      authorize resource
      resource.calculate_fees_and_donations
      resource.locked = true # Lock The Article
      resource.active = true # Activate to be searchable
      update! do |success, failure|
        success.html { redirect_to resource, :notice => I18n.t('article.notices.create') }
        failure.html {
                      resource_with_dependencies
                      render :edit
                     }
      end


  end

  def deactivate
      authorize resource
      resource.active = false # Deactivate - not searchable
      update! do |success, failure|
        success.html {  redirect_to resource, :notice => I18n.t('article.notices.deactivated') }
        failure.html {
                      #should not happen!
                      resource_with_dependencies
                      render :edit
                     }
      end
  end

  def report
    @text = params[:report]
    @article = Article.find(params[:id])
    if @text == ''
      redirect_to @article, :alert => (I18n.t 'article.actions.reported-error')
    else
      ArticleMailer.report_article(@article,@text).deliver
      redirect_to @article, :notice => (I18n.t 'article.actions.reported')
    end
  end


  ##### Private Helpers


  private


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


  ################## Form #####################
  def resource_with_dependencies
    build_questionnaires
    build_template
    build_transaction
    resource
  end

  def build_transaction
    resource.build_transaction unless resource.transaction
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
    @articles ||= search_for Article.new(params[:article])
  end

  def begin_of_association_chain
    current_user
  end

end

