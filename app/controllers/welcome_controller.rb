#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class WelcomeController < ApplicationController

  skip_before_filter :authenticate_user!, :only => [:index,:feed]
  skip_after_filter :verify_authorized_with_exceptions, :only => [:index,:feed,:reconfirm_terms]

  def index
    begin
      @featured_article = Article.active.featured
    rescue ActiveRecord::RecordNotFound
      @featured_article = nil
    end
  end

  # Rss Feed
  def feed
    @articles = Article.active.limit(20)

    respond_to do |format|
      format.rss { render :layout => false } #index.rss.builder
    end
  end

  def reconfirm_terms

    @user = current_user
    @active_old_articles = @user.articles.active_old.page(params[:active_old_articles_page])

    if request.post? && params[:reconfirm_terms]
      if params[:reconfirm_terms][:legal] == "1" && params[:reconfirm_terms][:privacy] == "1"
        @msg = ""
        # reconfirm the terms for the user
        @user.reconfirm_terms
        if params[:reconfirm_terms][:activate_to_buy] == "activate"
          # activate the articles to buy
          @active_old_articles.each do |active_old_article|
            active_old_article.confirm_to_buy
            active_old_article.save
          end
          @msg += "Artikel erfolgreich zum Verkauf freigeschalten."
        end
        @msg += "Benutzer erfolgreich freigeschalten!"
        flash[:notice] = @msg
        redirect_to profile_user_path(current_user)
      else
        flash[:error] = "Du musst die AGB und Datenschutzerklaehrung akzeptieren, bevor Du vorfahren kannst!"
        redirect_to welcome_reconfirm_terms_path
      end
    end

  end


end
