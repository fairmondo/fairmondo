#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class CategoriesController < ApplicationController
  layout false, only: :select_category
  respond_to :html
  respond_to :json, only: [:index, :show]
  respond_to :js, only: :show, if: lambda { request.xhr? }
  before_action :set_category, only: [:show, :select_category]
  before_action :build_category_search_cache, only: :show
  skip_before_action :authenticate_user!
  before_action :collection, only: [:index, :id_index]

  def index
    respond_with @categories
  end

  def id_index
    respond_with @categories
  end

  def select_category
    authorize @category
  end

  def show
    authorize @category

    @example_libraries = Library.for_category(@category.self_and_descendants)

    # exclude user's own libraries if he is logged in
    if user_signed_in?
      @example_libraries = @example_libraries.where('libraries.user_id != ?',
                                                    current_user.id)
    end

    # random() should work with PostgreSQL and SQLite
    @example_libraries = @example_libraries.reorder('random()').limit(2)

    respond_with @category do |format|
      format.html { articles }
      format.js   { articles }
      format.json { as_json  }
    end
  end

  def collection
    @categories = Category.other_category_last.sorted.roots
      .includes(children: { children: { children: :children } })
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def articles
    @articles = @search_cache.search params[:page]
  end

  def as_json
    @children = params[:hide_empty] ? @category.children_with_active_articles : @category.children
    render json: @children.map { |child| { id: child.id, name: child.name } }.to_json
  end

  def build_category_search_cache
    build_search_cache
    @search_cache.category_id = @category.id
  end
end
