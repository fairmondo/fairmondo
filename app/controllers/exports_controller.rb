class ExportsController < ApplicationController

  def show
     # Generate a Tempfile for the download
     csv = Tempfile.new "export"

     Article::Export.export_articles(csv,current_user, params[:kind_of_article])

     respond_to do |format|
       format.csv { send_file csv.path,
                   {filename: "Fairnopoly_export_#{Time.now.strftime("%Y-%d-%m %H:%M:%S")}.csv"} }
     end

  end
end