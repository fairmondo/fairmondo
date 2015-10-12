#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ExportsController < ApplicationController
  def show
    # Generate a Tempfile for the download
    csv = Tempfile.new 'export', encoding: 'utf-8'
    # export_type = ''

    # if params && params[:kind_of_article] == 'seller_line_item_groups'
    #  LineItemGroupExporter.export(csv, current_user, params)
    #  export_type = 'purchase'
    # else
    #
    #  ArticleExporter.export(csv, current_user, params[:kind_of_article])
    #  export_type = 'article'
    # end
    ArticleExporter.export(csv, current_user, params[:kind_of_article])

    respond_to do |format|
      format.csv do
        send_file csv.path,
                  type: 'text/csv; charset=utf-8',
                  filename: 'Fairmondo_export_'\
                            "#{Time.now.strftime('%Y-%d-%m %H:%M:%S')}.csv"
      end
    end
  end
end
