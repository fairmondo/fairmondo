# encoding: utf-8
# bugbug Only until the notice with Umlauts is moved to an i18n file

class MassUploadsController < ApplicationController
# bugbug Switch to inherited ressources?!

  def new
    authorize Article.new, :create? # Needed because of pundit
  end

  def create
    authorize Article.new, :create? # Needed because of pundit

    errors = []

    raw_articles = MassUpload.new(params[:file], current_user)
    if raw_articles.errors.full_messages.any?
      raw_articles.errors.full_messages.each do |message|
        errors << message
      end
    else
      articles = raw_articles
      articles.save
      if articles.errors.full_messages.any?
        articles.errors.full_messages.each do |message|
          errors << message
        end
      end
    end
    redirect_to new_mass_upload_path, alert: "#{errors.join("<br>")}"
  end
end