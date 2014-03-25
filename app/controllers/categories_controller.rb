class CategoriesController < InheritedResources::Base

  actions :show,:index

  skip_before_filter :authenticate_user!
  respond_to :json,:js, :only => :show
  respond_to :html, :only => [:index, :show]

  def show
    @children = resource.children
    @children = @children.delete_if { |child| child.children.empty? && child.active_articles.empty? } if params[:hide_empty]
    show! do |format|
      format.json do
        render :json => @children.map { |child| {id: child.id, name: child.name} }.to_json
      end
      format.html do
        @search_cache = SearchCache.new(permitted_search_params)
        @articles = @search_cache.articles
      end
    end
  end

  def collection
    @categories ||= Category.other_category_last.sorted_roots.includes(children: {children: :children})
  end

  def id_index
    @categories = Category.all_by_id
  end

  private
    def permitted_search_params
      params.permit :page, :keywords, article: Article.article_attrs
    end
end
