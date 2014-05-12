class CategoriesController < InheritedResources::Base
  actions :show, :index
  custom_actions resource: :select_category, collection: :id_index
  layout false, :only => :select_category
  respond_to :html
  respond_to :js, :json, only: :show, if: lambda { request.xhr? }

  before_filter :build_category_search_cache, only: :show
  skip_before_filter :authenticate_user!

  def show
    show! do |format|
      format.html { get_articles }
      format.js   { get_articles }
      format.json { as_json      }
    end
  end

  def collection
    @categories ||= Category.other_category_last.sorted.roots.includes(children: {children: {children: :children}})
  end

  private
    def get_articles
      @articles ||= @search_cache.search params[:page]
    rescue Errno::ECONNREFUSED
      @articles ||= policy_scope(Article).page params[:page]
    end

    def as_json
      @children = params[:hide_empty] ? resource.children_with_active_articles : resource.children
      render json: @children.map { |child| {id: child.id, name: child.name} }.to_json
    end

    def build_category_search_cache
      build_search_cache
      @search_cache.category_id = resource.id
    end
end
