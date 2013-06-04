class MassUploadsController < ApplicationController


  def create
    authorize Article.new, :create? # Because of pundit
    # bugbug Is there a better way to send the current_user (user_id is needed)
    # to the Article.import method?
    Article.import(params[:file], current_user)
    redirect_to user_path(current_user, anchor: "inactive"), notice: "Artikel importiert!?!?"
    # nach save methode die "rauspicken" die sich nicht saven lassen (z.B. Zeilennummer, title...)
  end
end