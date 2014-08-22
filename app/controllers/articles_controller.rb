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
class ArticlesController < ApplicationController

  responders :location
  respond_to :html
  respond_to :js, only: :index, if: lambda { request.xhr? }

  # Authorization
  skip_before_filter :authenticate_user!, only: [:show, :index, :autocomplete]
  skip_after_filter :verify_authorized_with_exceptions, only: [:autocomplete]

  # Layout Requirements
  before_filter :ensure_complete_profile , only: [:new, :create]

  #search_cache
  before_filter :build_search_cache, only: :index
  before_filter :category_specific_search, only: :index, unless: lambda { request.xhr? }

  # Calculate value of active goods
  before_filter :check_value_of_goods, only: [:update], if: :activate_params_present?

  before_filter :set_article, only: [:edit, :update, :show, :destroy]


  #Autocomplete
  def autocomplete
    @form = ArticleSearchForm.new(q: params[:q])
    render :json => @form.autocomplete
  rescue Errno::ECONNREFUSED
    render :json => []
  end

  def show
    authorize @article

    @user_libraries = current_user.libraries.includes(:articles) if current_user
    @containing_libraries = @article.libraries.includes(user: [:image]).published.limit(10)

    if !@article.active? && policy(@article).activate?
      @article.calculate_fees_and_donations
    end

    if !flash.now[:notice] && @article.owned_by?(current_user) && at_least_one_image_processing?
      flash.now[:notice] = t('article.notices.image_processing')
    end

  rescue Pundit::NotAuthorizedError
    raise ActiveRecord::RecordNotFound # hide articles that can't be accessed to generate more friendly error messages
  end

  def index
    @articles = @search_cache.search params[:page]
    respond_with @articles
  end

  def new
    ############### From Template ################
    if params[:template] && params[:template][:article_id].present?
      template = current_user.articles.unscoped.find(params[:template][:article_id])
      @article = template.amoeba_dup
      flash.now[:notice] = t('template.notices.applied', :name => template.template_name)
    elsif params[:edit_as_new]
      @old_article = current_user.articles.find(params[:edit_as_new])
      @article = Article.edit_as_new @old_article
    else
      @article = current_user.articles.build
    end
    authorize @article
  end

  def edit
    authorize @article
  end

  def create
    @article = current_user.articles.build(params.for(Article).refine)
    authorize @article
    save_images unless @article.save
    respond_with @article
  end

  def update # Still needs Refactoring
    if state_params_present?
      change_state!
    else
      authorize @article
      save_images unless @article.update(params.for(@article).refine)
      respond_with @article
    end
  end

  def destroy
    authorize @article

    if @article.preview?
      @article.destroy
    elsif @article.locked?
      @article.close_without_validation
    end
    respond_with @article, location: -> { user_path(current_user) }
  end

  ##### Private Helpers

  private

    def set_article
      @article = Article.find(params[:id])
    end

    def change_state!

      # For changing the state of an article
      # Refer to Article::State
      if params[:activate]
        authorize @article, :activate?
        if @article.activate
          flash[:notice] = I18n.t('article.notices.create_html')
          redirect_to @article
        else
          # The article became invalid so please try a new one
          redirect_to new_article_path(:edit_as_new => @article.id)
        end
      elsif params[:deactivate]
        authorize @article, :deactivate?
        @article.deactivate_without_validation
        flash[:notice] = I18n.t('article.notices.deactivated')
        redirect_to @article
      end
    end

    def state_params_present?
      params[:activate] || params[:deactivate]
    end

    def activate_params_present?
      !!params[:activate]
    end

    ############ Images ################

    def save_images
      #At least try to save the images -> not persisted in browser
      @article.images.each_with_index do |image,index|
        if image.new_record?
          # strange HACK because paperclip will now rollback uploaded files and we want the file to be saved anyway
          # if you find aout a way to break out a running transaction please refactor to images_attributes
          image.image = params[:article][:images_attributes][index.to_s][:image]
        end
        image.save
      end
    end

    def at_least_one_image_processing?
      processing_thumbs = @article.thumbnails.select { |thumb| thumb.image.processing? }
      !processing_thumbs.empty? || (@article.title_image and @article.title_image.image.processing?)
    end

  ################## Inherited Resources

  protected


    def category_specific_search
      if @search_cache.category_id.present?
        params[:article_search_form].delete(:category_id)
        params.delete(:article_search_form) if params[:article_search_form].empty?
        redirect_to category_path(@search_cache.category_id, params)
      end
    end
end
