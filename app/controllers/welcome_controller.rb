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

  skip_before_filter :authenticate_user!, :only => [:index, :feed, :landing]

  def index
    query_object = FeaturedLibraryQuery.new
    @queue1 = query_object.set(:queue1).find(3)
    #@queue2 = query_object.set(:queue2).find(1)
    #@queue4 = query_object.set(:queue4).find(1)
    @queue3 = query_object.set(:queue3).find(2)
    @old = query_object.set(:old).find(2)
    @donation_articles = query_object.set(:donation_articles).find(2)

    # Libraries that are trending
    # TODO: Nur Libraries, die im Moment öffentlich sind! Am besten über einen Join
    active_hearts = Heart.select("count(id) as num_hearts, heartable_id").group(:heartable_id).where(updated_at: 180.minutes.ago..Time.now).order('count(id) DESC').first(3)
    @libraries_trending = []
    active_hearts.each do |heart|
      library = Library.find(heart.heartable_id)
      @libraries_trending.push(library)
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
