class MassUploadsController < ApplicationController

  # Layout Requirements
  before_filter :ensure_complete_profile , :only => [:new, :create]
  before_filter :authorize_with_article_create

  def new
    @mass_upload = MassUpload.new
  end

  def show
    secret_mass_uploads_number = params[:id]
    @articles = Article.find_all_by_id(session[secret_mass_uploads_number]).sort_by(&:created_at)
  end

  def create
    @mass_upload = MassUpload.new(permitted_params[:mass_upload])

    if @mass_upload.parse_csv_for current_user
      redirect_to mass_upload_path generate_session_for @mass_upload.articles
    else
      render :new
    end
  end

  def update
    secret_mass_uploads_number = params[:id]
    articles = Article.find_all_by_id(session[secret_mass_uploads_number])
    articles.each do |article|
      #Skip validation in favor of performance
      article.update_column :state, 'active'
      article.solr_index!
    end
    flash[:notice] = I18n.t('article.notices.mass_upload_create_html').html_safe
    redirect_to user_path(current_user)
  end

  private
    def authorize_with_article_create
      # Needed because of pundit
      authorize Article.new, :create?
    end

    def generate_session_for(uploaded_articles)
      secret_mass_uploads_number = SecureRandom.urlsafe_base64
      session[secret_mass_uploads_number] = []
      uploaded_articles.each do |article|
        session[secret_mass_uploads_number] << article.id
      end
      secret_mass_uploads_number
    end
end
