# encoding: utf-8
# bugbug Only until the notice with Umlauts is moved to an i18n file

class MassUploadsController < ApplicationController
# bugbug Switch to inherited ressources?!

  def new
    authorize Article.new, :create? # Needed because of pundit

    @mass_upload = MassUpload.new(user = current_user)
  end

  def show
    authorize Article.new, :create? # Needed because of pundit

    secret_mass_uploads_number = params[:id]
    @articles = Article.find_all_by_id(session[secret_mass_uploads_number])
  end


  def create
    authorize Article.new, :create? # Needed because of pundit

    @mass_upload = MassUpload.new(current_user, params[:mass_upload])

    # Needed to show the right error messages if no file is selected since in
    # this case .new doesn't lead to the validate_input method.
    @mass_upload.validate_input(params[:mass_upload])

    if @mass_upload.errors.full_messages.any?
      render :new
    else
      secret_mass_uploads_number = SecureRandom.urlsafe_base64
      @test = secret_mass_uploads_number
      session[secret_mass_uploads_number] = []
      articles = @mass_upload
      articles.save
      articles.raw_articles.each do |article|
        session[secret_mass_uploads_number] << article.id
      end
      if articles.errors.full_messages.any?
        render :new
      else
        redirect_to mass_upload_path(secret_mass_uploads_number)
      end
    end
  end
end
