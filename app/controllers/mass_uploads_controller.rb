class MassUploadsController < InheritedResources::Base
  actions :update, :show, :new, :create

  # Layout Requirements
  before_filter :ensure_complete_profile , :only => [:new, :create]
  before_filter :authorize_resource, only: [:show, :update]
  before_filter :authorize_build_resource, only: [:new, :create]
  before_filter :check_value_of_goods, :only => [:update]

  def show
    @created_articles = resource.created_articles.page(params[:created_articles_page])
    @updated_articles = resource.updated_articles.page(params[:updated_articles_page])
    @activated_articles = resource.activated_articles.page(params[:activated_articles_page])
    @deactivated_articles = resource.deactivated_articles.page(params[:deactiated_articles_page])
    @deleted_articles = resource.deleted_articles.page(params[:deleted_articles_page])
    @erroneous_articles = resource.erroneous_articles.page(params[:erroneous_articles_page])
    show! do |format|
      format.csv { send_data Article::Export.export_erroneous_articles(resource.erroneous_articles),
                   {filename: "Fairnopoly_export_errors_#{Time.now.strftime("%Y-%d-%m %H:%M:%S")}.csv"} }
    end
  end

  def create
    create! do |success, failure|
      success.html do
        resource.process
        redirect_to user_path(resource.user, anchor: "my_mass_uploads")
      end
    end
  end

  def update
    articles_to_activate = resource.articles_for_mass_activation
    activation_ids = articles_to_activate.map{ |article| article.id }
    articles_to_activate.update_all({:state => 'active'})
    MassUpload.delay.update_solr_index_for activation_ids
    flash[:notice] = I18n.t('article.notices.mass_upload_create_html').html_safe
    redirect_to user_path(resource.user)
  end

  protected
    def begin_of_association_chain
      current_user
    end


end
