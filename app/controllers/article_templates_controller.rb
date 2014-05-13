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
class ArticleTemplatesController < InheritedResources::Base

  before_filter :build_resource, only: [:new, :create]
  before_filter :build_article, only: [:new,:create]
  before_filter :authorize_resource, except: [:create]
  before_filter :render_css_from_articles_controller, except: [:destroy]

  actions :all, :except => [:show,:index]

  def update
    update! do |success, failure|
      success.html { redirect_to collection_url}
      failure.html { save_images
                     render :edit}
    end
  end

  def create
    authorize build_resource
    create! do |success, failure|
      success.html { redirect_to collection_url}
      failure.html { save_images
                     render :new}
    end
  end

  def destroy
    destroy! {collection_url}
  end

  private

    def begin_of_association_chain
      current_user
    end

    def collection_url
      user_path(current_user, :anchor => "my_article_templates")
    end

    def build_article
      resource.build_article unless resource.article
      resource.article.seller = current_user
    end

    def save_images
      #At least try to save the images -> not persisted in browser
      if resource.article
        resource.article.images.each do |image|
          ## I tried for hours but couldn't figure out a way to write a test that transmit a wrong image.
          ## If the image removal is ever needed, comment it back in. ArticlesController doesn't use it either. -KK
          # if image.image
            image.save
          # else
          #   @article.images.remove image
          # end
        end
      end
    end

    def render_css_from_articles_controller
      @controller_specific_css = 'articles'
    end
end
