#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module LibrariesControllerAdminActions
  extend ActiveSupport::Concern

  included do
    # for admins to quickly add one or more articles to any library
    def admin_add
      authorize @exhibition
      add_articles_to_exhibition if can_add_to_exhibition?
      redirect_to :back, flash: @admin_add_notice
    end
    #
    # for admins to quickly remove an article from a featured library
    def admin_remove
      library = Library.where(exhibition_name: params[:exhibition_name]).first
      authorize library

      library.articles.delete Article.find(params[:article_id])
      redirect_to :back, notice: 'Deleted from library.'
    end

    # for admins to audit libraries for display on the welcome page
    def admin_audit
      authorize @library
      @library.update_column :audited, !@library.audited
      respond_with @library do |format|
        format.js { render 'admin_audit' }
      end
    end

    private

    def set_exhibition
      @exhibition = Library
        .where(exhibition_name: params[:library][:exhibition_name])
        .first
    end

    def can_add_to_exhibition?
      params[:library][:exhibition_name] &&
        (params[:library][:articles] ||
         params[:library][:article_id])
    end

    def add_articles_to_exhibition
      @exhibition.articles << Article.find(article_ids_from_params)
      @admin_add_notice = { notice: 'Added to library.' }
    rescue => err
      # will throw errors e.g. if library already had that article
      # Only visible for admins
      @admin_add_notice = { error: "Something went wrong: #{err}" }
    end

    def article_ids_from_params
      (params[:library][:articles] || [params[:library][:article_id]])
        .select(&:present?)
    end
  end
end
