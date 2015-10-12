#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ArticleTemplatesController < ApplicationController
  respond_to :html
  responders :location, :flash

  before_action -> { render_css_from_controller('articles') }, except: [:destroy]
  before_action :set_article_template, only: [:edit, :update, :destroy]

  def new
    @article_template = current_user.articles.build
    authorize @article_template
  end

  def edit
    authorize @article_template
  end

  def update
    authorize @article_template

    save_images unless @article_template.update(params.for(@article_template).refine)
    respond_with(@article_template, location: -> { collection_url })
  end

  def create
    @article_template = current_user.articles.build(params.for(Article).refine)
    authorize @article_template
    @article_template.state = :template

    save_images unless @article_template.save
    respond_with(@article_template, location: -> { collection_url })
  end

  def destroy
    authorize @article_template
    @article_template.destroy
    respond_with(@article_template, location: -> { collection_url })
  end

  private

  def set_article_template
    @article_template = Article.unscoped.find(params[:id])
  end

  def collection_url
    user_path(current_user, anchor: 'my_article_templates')
  end

  def save_images
    # At least try to save the images -> not persisted in browser
    @article_template.images.each do |image|
      image.save
    end
  end
end
