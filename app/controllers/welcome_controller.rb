#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :feed, :landing]

  def index
    set_article_queues
    set_last_hearted_libraries_if_signed_in
    set_trending_libraries
  end

  # Rss Feed
  def feed
    @articles = Article.active.limit(20)

    respond_to do |format|
      format.rss { render layout: false } # index.rss.builder
    end
  end

  private

  def set_article_queues
    query_object = FeaturedLibraryQuery.new
    @queue1 = query_object.set(:queue1).find(2)
    @queue2 = query_object.set(:queue2).find(2)
    @donation_articles = query_object.set(:donation_articles).find(2)
  end

  def set_last_hearted_libraries_if_signed_in
    if user_signed_in?
      @last_hearted_libraries = User.hearted_libraries_current(current_user)
                                    .includes(:user).limit(2)
    end
  end

  def set_trending_libraries
    @trending_libraries = Library.trending_welcome_page
      .includes(user: [:image], comments: { user: [:image] })
  end
end
