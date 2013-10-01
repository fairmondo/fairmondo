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

  def index
    begin
      @pioneer_article = Article.active.pioneer_article
      @pioneer_article2 = Article.active.pioneer_article2
      @dream_team_article = Article.active.dreamteam_article
      @dream_team_article2 = Article.active.dreamteam_article2
      @newest_article = Article.active.newest_article
      @newest_article2 = Article.active.newest_article2
    rescue ActiveRecord::RecordNotFound
      @pioneer_article = nil
      @pioneer_article2 = nil
      @dream_team_article = nil
      @dream_team_article2 = nil
      @newest_article = nil
      @newest_article2 = nil
    end
  end

  # Rss Feed
  def feed
    @articles = Article.active.limit(20)

    respond_to do |format|
      format.rss { render :layout => false } #index.rss.builder
    end
  end

end
