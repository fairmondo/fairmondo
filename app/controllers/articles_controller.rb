#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ArticlesController < ApplicationController
  include ArticleControllerFilters

  responders :location
  respond_to :html
  respond_to :json, only: [:show, :index]

  rescue_from ActiveRecord::RecordNotFound, with: :similar_articles,
                                            only: :show

  # Autocomplete
  def autocomplete
    render json: ArticleAutocomplete.new(params[:q]).autocomplete
  rescue Faraday::ConnectionFailed
    search_results_for_error_case
  rescue Faraday::TimeoutError
    search_results_for_error_case
  rescue Faraday::ClientError
    search_results_for_error_case
  end

  def show
    authorize @article

    @user_libraries = current_user.libraries if current_user
    @containing_libraries = @article.libraries.published.limit(10)
  rescue Pundit::NotAuthorizedError
    similar_articles @article.title
  end

  def index
    @articles = @search_cache.search params[:page]
    respond_with @articles
  end

  def create
    @article = current_user.articles.build(params.for(Article).refine)
    if params && params[:article][:article_template_name].present?
      @article.save_as_template = '1'
    end
    authorize @article
    save_images unless @article.save
    respond_with @article
  end

  def new
    if params[:template] && params[:template][:article_id].present?
      new_from_template
    elsif params[:edit_as_new]
      edit_as_new
    else
      new_article
    end
    authorize @article
  end

  def edit
    authorize @article
  end

  def update # Still needs Refactoring
    if state_params_present?
      change_state
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
    else
      @article.deactivate! if @article.active?
      @article.close_without_validation
    end
    flash[:notice] = I18n.t('article.notices.destroyed')
    respond_with @article, location: -> { user_path(current_user) }
  end

  ##### Private Helpers

  private

  def search_results_for_error_case
    render json: { query: params[:q], suggestions: [] }
  end

  def calculate_fees_and_donations
    @article.calculate_fees_and_donations
  end

  def flash_image_processing_message
    flash.now[:notice] = t('article.notices.image_processing')
  end

  def seller_sign_in
    # If user is not logged in, redirect to sign in page with parameter for
    # sessions view.
    unless user_signed_in?
      redirect_to controller: :sessions, action: :new, seller: true
    end
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def similar_articles query
    query ||= params[:id].gsub(/\-/, ' ')
    @similar_articles = ArticleSearchForm.new(q: query).search(1)
    respond_with @similar_articles do |format|
      format.html { render 'article_closed' }
      format.json { render 'article_closed' }
    end
  end

  def change_state
    # For changing the state of an article
    # Refer to Article::State
    if params[:activate]
      activate
    elsif params[:deactivate]
      deactivate
    end
  end

  def activate
    @article.assign_attributes params.for(@article).refine
    authorize @article, :activate?
    if @article.activate
      flash[:notice] = I18n.t('article.notices.create_html')
      redirect_to @article
    elsif @article.errors.keys.include? :tos_accepted
      # TOS weren't accepted, redirect back to the form
      flash[:error] = I18n.t('article.notices.activation_failed')
      render :show
    else
      # The article became invalid so please try a new one
      redirect_to new_article_path(edit_as_new: @article.id)
    end
  end

  def deactivate
    authorize @article, :deactivate?
    @article.deactivate_without_validation
    flash[:notice] = I18n.t('article.notices.deactivated')
    redirect_to @article
  end

  def state_params_present?
    params[:activate] || params[:deactivate]
  end

  def activate_params_present?
    !!params[:activate]
  end

  # used in for new articles
  #
  def new_from_template
    template = current_user.articles.unscoped.find(params[:template][:article_id])
    @article = template.amoeba_dup
    clear_template_name
    flash.now[:notice] = t('template.notices.applied', name: template.article_template_name)
  end

  def edit_as_new
    @old_article = current_user.articles.find(params[:edit_as_new])
    @article = Article.edit_as_new @old_article
    clear_template_name
  end

  def new_article
    @article = current_user.articles.build
  end

  def clear_template_name
    @article.article_template_name = nil
  end

  ############ Images ################

  def save_images
    # At least try to save the images -> not persisted in browser
    @article.images.each_with_index do |image, index|
      if image.new_record?
        # strange HACK because paperclip will now rollback uploaded files and we want the file to be saved anyway
        # if you find out a way to break out a running transaction please refactor to images_attributes
        image.image = params[:article][:images_attributes][index.to_s][:image]
      end
      image.save
    end
  end

  def at_least_one_image_processing?
    processing_thumbs = @article.thumbnails.select { |thumb| thumb.image.processing? }
    !processing_thumbs.empty? || (@article.title_image && @article.title_image.image.processing?)
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
