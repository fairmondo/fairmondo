# encoding: utf-8
# bugbug Only until the notice with Umlauts is moved to an i18n file

class MassUploadsController < ApplicationController
# bugbug Switch to inherited ressources?!

  def new
    authorize Article.new, :create? # Needed because of pundit
    @mass_uploads = MassUpload.new(user = current_user)
  end

  def create
    authorize Article.new, :create? # Needed because of pundit

    errors = []

    @mass_upload = MassUpload.new(params[:mass_uploads], current_user)
    if @mass_upload.errors.full_messages.any?
      @mass_upload.errors.full_messages.each do |message|
        errors << message
      end
    else
      articles = @mass_upload
      articles.save
      if articles.errors.full_messages.any?
        articles.errors.full_messages.each do |message|
          errors << message
        end
      end
    end
    render new_mass_upload_path #, alert: "#{errors.join("<br>")}"
  end
end