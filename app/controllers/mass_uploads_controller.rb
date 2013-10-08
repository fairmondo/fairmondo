class MassUploadsController < ApplicationController

  # Layout Requirements
  before_filter :ensure_complete_profile , :only => [:new, :create]

  def new
    authorize Article.new, :create? # Needed because of pundit

    @mass_upload = MassUpload.new
  end

  def show
    authorize Article.new, :create? # Needed because of pundit
    secret_mass_uploads_number = params[:id]
    @articles = Article.find_all_by_id(session[secret_mass_uploads_number]).sort_by(&:created_at)
  end

  def create
    # bugbug Move model logic into model (@mass_upload use_count > 4)
    authorize Article.new, :create? # Needed because of pundit

    # bugbug Not needed if we test the existence of the file in the initializer with the create_method variable
    # @mass_upload = MassUpload.file_selected?(params[:mass_upload])
    # return render :new if @mass_upload.errors.full_messages.any?
    @mass_upload = MassUpload.new(params[:mass_upload])
    unless @mass_upload.parse_csv_for(current_user)
      return render :new
    end
    # bugbug errors.full_messages.any? in valid? "umbenennen"

    # Needed to show the right error messages if no file is selected since in
    # this case .new doesn't lead to the validate_input method.

    #Check if can be put in the model (eg mass_upload.valid?)?
    # @mass_upload.file_selected?(params[:mass_upload])

    redirect_to mass_upload_path(generate_session_for(@mass_upload.articles))
  end

  def update
    authorize Article.new, :create? # Needed because of pundit

    secret_mass_uploads_number = params[:id]
    articles = Article.find_all_by_id(session[secret_mass_uploads_number])
    articles.each do |article|
      article.activate
      flash[:notice] = I18n.t('article.notices.mass_upload_create_html').html_safe if article.valid?
    end
    redirect_to user_path(current_user)
  end

  private
    def generate_session_for(uploaded_articles)
      secret_mass_uploads_number = SecureRandom.urlsafe_base64
      session[secret_mass_uploads_number] = []
      uploaded_articles.each do |article|
        session[secret_mass_uploads_number] << article.id
      end
      secret_mass_uploads_number
    end
end