class MassUploadsController < InheritedResources::Base
  actions :update, :show, :new, :create

  # Layout Requirements
  before_filter :ensure_complete_profile , :only => [:new, :create]
  before_filter :authorize_resource, only: [:show, :update]
  before_filter :authorize_build_resource, only: [:new, :create]

  def show
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
    articles = resource.articles.where("activation_action IS NOT NULL")

    articles.each do |article|
      #Skip validation in favor of performance
      article.update_column :state, 'active'
      article.solr_index!
    end
    flash[:notice] = I18n.t('article.notices.mass_upload_create_html').html_safe
    redirect_to user_path(resource.user)
  end

  protected
    def begin_of_association_chain
      current_user
    end

end
