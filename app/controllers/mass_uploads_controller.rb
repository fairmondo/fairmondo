class MassUploadsController < InheritedResources::Base
  actions :update, :show, :new, :create

  # Layout Requirements
  before_filter :ensure_complete_profile , :only => [:new, :create]
  before_filter :authorize_with_article_create

  # def show
  #   upload_id = params[:id]
  #   @mass_upload = MassUpload.compile_report_for session[upload_id]
  #   @activate_articles = activate_articles upload_id
  # end

  # def create
  #   @mass_upload = MassUpload.new(permitted_params[:mass_upload])

  #   if @mass_upload.parse_csv_for current_user
  #     redirect_to mass_upload_path generate_session_for @mass_upload.articles
  #   else
  #     render :new
  #   end
  # end

  # def update
  #   upload_id = params[:id]
  #   articles = Article.find_all_by_id(activate_articles(upload_id))
  #   articles.each do |article|
  #     #Skip validation in favor of performance
  #     article.update_column :state, 'active'
  #     article.solr_index!
  #   end
  #   flash[:notice] = I18n.t('article.notices.mass_upload_create_html').html_safe
  #   redirect_to user_path(current_user)
  # end

  # def image_errors
  #   @error_articles = current_user.articles.joins(:images).includes(:images).where("images.failing_reason is not null AND articles.state is not 'closed' ")
  # end

  private
    def authorize_with_article_create
      # Needed because of pundit
      authorize Article.new, :create?
    end

    # def generate_session_for(uploaded_articles)
    #   upload_id = SecureRandom.urlsafe_base64
    #   session[upload_id] = MassUpload.prepare_session_hash
    #   uploaded_articles.each do |article|
    #     session[upload_id][article.action] << article.id
    #   end
    #   upload_id
    # end

    # def activate_articles upload_id
    #   articles = []
    #   [:create,:update,:activate].each do |action|
    #     articles += session[upload_id][action]
    #   end
    #   Article.find_all_by_id(articles)
    # end
end
