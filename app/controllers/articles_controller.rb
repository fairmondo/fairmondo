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
class ArticlesController < InheritedResources::Base

  # Inherited Resources
  respond_to :html
  respond_to :js, only: :index, if: lambda { request.xhr? }
  actions :all # inherited methods

  # Authorization
  skip_before_filter :authenticate_user!, only: [:show, :index, :autocomplete]
  skip_after_filter :verify_authorized_with_exceptions, only: [:autocomplete]

  # Layout Requirements
  before_filter :ensure_complete_profile , only: [:new, :create]

  #search_cache
  before_filter :category_specific_search, only: :index, unless: lambda { request.xhr? }
  before_filter :build_search_cache, only: :index

  # Calculate value of active goods
  before_filter :check_value_of_goods, only: [:update], if: :activate_params_present?


  #Autocomplete
  def autocomplete
    @form = ArticleSearchForm.new(q: params[:q])
    render :json => @form.autocomplete
  rescue Errno::ECONNREFUSED
    render :json => []
  end


  def show
    authorize resource
    
    @other_articles = ActiveUserArticles.new(resource.seller).find_some
    @libraries = resource.libraries.where(:public => true).page(params[:library_page]).per(10)
    
    if !resource.active? && policy(resource).activate?
      resource.calculate_fees_and_donations
    end

    if !flash.now[:notice] && resource.owned_by?(current_user) && at_least_one_image_processing?
      flash.now[:notice] = t('article.notices.image_processing')
    end

    show!
  rescue Pundit::NotAuthorizedError
    raise ActiveRecord::RecordNotFound # hide articles that can't be accessed to generate more friendly error messages
  end


  def new
    authorize build_resource

    ############### From Template ################
    if @applied_template = ArticleTemplate.template_request_by(current_user, params[:template_select])
      @article = @applied_template.article.amoeba_dup
      flash.now[:notice] = t('template_select.notices.applied', :name => @applied_template.name)
    elsif params[:edit_as_new]
      @old_article = current_user.articles.find(params[:edit_as_new])
      @article = Article.edit_as_new @old_article
    end
    new!
  end


  def edit
    authorize resource
    edit!
  end


  def create
    authorize build_resource
    create! do |success, failure|
      success.html { redirect_to resource }
      failure.html { save_images
                     render :new }
    end
  end


  def update # Still needs Refactoring
    if state_params_present?
      change_state!
    else
      authorize resource
      update! do |success, failure|
        success.html { redirect_to resource }
        failure.html { save_images
                       render :edit }
      end
    end
  end


  def destroy
    authorize resource
    if resource.preview?
      destroy! { user_path(current_user) }
    elsif resource.locked?
      resource.close_without_validation

      redirect_to user_path(current_user)
    end
  end


##### Private Helpers

  private

    def change_state!

      # For changing the state of an article
      # Refer to Article::State
      if params[:activate]
        authorize resource, :activate?
        if resource.activate
          flash[:notice] = I18n.t('article.notices.create_html').html_safe
          redirect_to resource
        else
          # The article became invalid so please try a new one
          redirect_to new_article_path(:edit_as_new => resource.id)
        end
      elsif params[:deactivate]
        authorize resource, :deactivate?
        resource.deactivate_without_validation
        flash[:notice] = I18n.t('article.notices.deactivated')
        redirect_to resource
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
      resource.images.each_with_index do |image,index|
        if image.new_record?
          # strange HACK because paperclip will now rollback uploaded files and we want the file to be saved anyway
          # if you find aout a way to break out a running transaction please refactor to images_attributes
          image.image = params[:article][:images_attributes][index.to_s][:image]
        end
        image.save
      end
    end


    def at_least_one_image_processing?
      processing_thumbs = resource.thumbnails.select { |thumb| thumb.image.processing? }
      !processing_thumbs.empty? || (resource.title_image and resource.title_image.image.processing?)
    end


  ################## Inherited Resources

  protected

    def collection
      @articles ||= @search_cache.search params[:page]
    rescue Errno::ECONNREFUSED
      @articles ||= policy_scope(Article).page params[:page]
    end


    def begin_of_association_chain
      params[:action] == "show" ? super : current_user
    end

    def category_specific_search
      if params[:article_search_form] && params[:article_search_form][:category_id] && !params[:article_search_form][:category_id].empty?
        redirect_to category_path params[:article_search_form][:category_id], params
      end
    end

end
