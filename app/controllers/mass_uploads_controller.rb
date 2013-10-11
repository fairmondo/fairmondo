class MassUploadsController < ApplicationController

  def new
    authorize Article.new, :create? # Needed because of pundit

    @mass_upload = MassUpload.new(user = current_user)
  end

  def show
    authorize Article.new, :create? # Needed because of pundit
    secret_mass_uploads_number = params[:id]
    @articles = Article.find_all_by_id(session[secret_mass_uploads_number]).sort_by(&:created_at)
  end

  def create
    # bugbug Move model logic into model (@mass_upload use_count > 4)
    authorize Article.new, :create? # Needed because of pundit

    @mass_upload = MassUpload.new(current_user, params[:mass_upload])

    # Needed to show the right error messages if no file is selected since in
    # this case .new doesn't lead to the validate_input method.
    @mass_upload.file_selected?(params[:mass_upload])
    if @mass_upload.errors.full_messages.any?
      render :new
    else
      secret_mass_uploads_number = SecureRandom.urlsafe_base64
      session[secret_mass_uploads_number] = []
      @mass_upload.save
      @mass_upload.raw_articles.each do |article|
        session[secret_mass_uploads_number] << article.id
      end
      if @mass_upload.errors.full_messages.any?
        if @mass_upload.missing_bank_details_errors?
          flash[:alert] = @mass_upload.add_missing_bank_details_errors_notice.html_safe
          redirect_to edit_user_registration_path(current_user)
        else
          render :new
        end
      else
        redirect_to mass_upload_path(secret_mass_uploads_number)
      end
    end
  end

  def update
    authorize Article.new, :create? # Needed because of pundit

    secret_mass_uploads_number = params[:id]
    articles = Article.find_all_by_id(session[secret_mass_uploads_number])
    articles.each do |article|
      article.update_attribute(:state,"active")
      article.solr_index!
      flash[:notice] = I18n.t('article.notices.mass_upload_create_html').html_safe if article.valid?
    end
    redirect_to user_path(current_user)
  end
end
