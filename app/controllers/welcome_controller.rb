#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :feed, :landing]

  def index
    query_object = FeaturedLibraryQuery.new
    @queue1 = query_object.set(:queue1).find(2)
    @queue2 = query_object.set(:queue2).find(2)
    # @queue4 = query_object.set(:queue4).find(1)
    # @queue3 = query_object.set(:queue3).find(2)
    # @old = query_object.set(:old).find(2)
    @donation_articles = query_object.set(:donation_articles).find(2)

    # Libraries
    @trending_libraries = Library.trending_welcome_page
      .includes(user: [:image], comments: { user: [:image] })

    # Personalized section
    if user_signed_in?
      @last_hearted_libraries = User.hearted_libraries_current(current_user)
                                    .includes(:user).limit(2)
    end
  end

  # Rss Feed
  def feed
    @articles = Article.active.limit(20)

    respond_to do |format|
      format.rss { render layout: false } # index.rss.builder
    end
  end
end
