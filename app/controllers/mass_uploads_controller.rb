class MassUploadsController < ApplicationController

  def show # bugbug Is this really needed?
    authorize Article.new, :create? # Needed because of pundit
  end

  def new
    authorize Article.new, :create? # Needed because of pundit
  end

  def index
    if Article.find_all_by_id(session[:mass_upload]).empty?
      redirect_to new_article_path, notice: "Keine aktuell hochgeladenen Artikel
                                             vorhanden!"
    else
      @articles = Article.find_all_by_id(session[:mass_upload])
    end
  end


  def create
    authorize Article.new, :create? # Needed because of pundit
    if params[:file]
      rows_array = Article.import(params[:file], current_user)
      session[:mass_upload] = []
      rows_array.each do |row|
        Article.create(row.to_hash)
        session[:mass_upload] << Article.last.id
      end
    else
      redirect_to new_mass_upload_path, notice: "Bitte eine gültige .csv Datei
                                                auswählen"
      return # Is there a better alternative?
    end
    redirect_to mass_uploads_path, notice: "Artikel hochgeladen"
    # redirect_to user_path(current_user, anchor: "inactive"), notice: "Artikel importiert!?!?"
    # nach save methode die "rauspicken" die sich nicht saven lassen (z.B. Zeilennummer, title...)
  end
end