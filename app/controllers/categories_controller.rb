class CategoriesController < InheritedResources::Base
  actions :show, :index
  custom_actions resource: :select_category, collection: :id_index
  layout false, :only => :select_category
  respond_to :html
  respond_to :js, :json, only: :show, if: lambda { request.xhr? }

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
      begin
        @search_cache = ArticleSearchForm.new(refined_params[:article_search_form])
        @articles ||= @search_cache.search refined_params[:page]
      rescue Errno::ECONNREFUSED
        @articles ||= policy_scope(Article).page refined_params[:page]
      end
    end

    def as_json
      @children = params[:hide_empty] ? resource.children_with_active_articles : resource.children
      render json: @children.map { |child| {id: child.id, name: child.name} }.to_json
    end

    def refined_params
      super
      @refined_params[:article_search_form] ||= {}
      search_params = params.for(ArticleSearchForm)[:article_search_form]
      @refined_params[:article_search_form].merge search_params if search_params
      @refined_params[:article_search_form][:category_id] = resource.id
      @refined_params
    end
end
