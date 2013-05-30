class MassUploadsController < ApplicationController

  def create
    Article.import(params[:file])
    redirect_to new_article_path, notice: "Artikel importiert!?!?"
  end
end