class ExportsController < ApplicationController

  def show
     tempfile = Article::Export.export_articles(current_user, params[:kind_of_article])
     respond_to do |format|
       format.csv { send_file tempfile.path,
                   {filename: "Fairnopoly_export_#{Time.now.strftime("%Y-%d-%m %H:%M:%S")}.csv"} }
     end

  end
end