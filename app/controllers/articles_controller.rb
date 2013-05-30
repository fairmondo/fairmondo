class ArticlesController < InheritedResources::Base

  # Inherited Resources

  respond_to :html

  actions :all, :except => [ :destroy ] # inherited methods

  # Authorization
  before_filter :authenticate_user!, :except => [:show, :index, :autocomplete]

  # Layout Requirements

  before_filter :build_login , :unless => :user_signed_in?, :only => [:show,:index]

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

    if state_params_present?
      change_state!
    else
      authorize resource
    end

    update! do |success, failure|
      success.html { redirect_to resource }
      failure.html { resource_with_dependencies
                     save_images
                     render :edit }
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

  def change_state!

    # For changing the state of an article
    # Refer to Article::State

    if params[:activate]
      params.delete :article # Do not allow any other change
      authorize resource, :activate?
      resource.activate
      flash[:notice] = I18n.t('article.notices.create') if resource.valid?
    elsif params[:deactivate]
      params.delete :article # Do not allow any other change
      authorize resource, :deactivate?
      resource.deactivate
      flash[:notice] = I18n.t('article.notices.deactivated')
    end
  end

  def state_params_present?
    params[:activate] || params[:deactivate]
  end


  def search_for query
    ######## Solr
      search = query.find_like_this params[:page]
      return search.results
    ########
    rescue Errno::ECONNREFUSED
      render_hero :action => "sunspot_failure"
      return policy_scope(Article).paginate :page => params[:page]
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

