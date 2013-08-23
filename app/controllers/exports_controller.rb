class ExportsController < ApplicationController

  def show
    respond_to do |format|
      format.csv { send_data Article.export_articles(current_user,
                   params[:kind_of_article]),
                   {filename: "Fairnopoly_export_#{Time.now.strftime("%Y-%d-%m %H:%M:%S %Z")}.csv"} }
    end
  end
end