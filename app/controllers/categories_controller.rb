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
        begin
          @search_cache = ArticleSearchForm.new permitted_search_params[:article_search_form]
          @articles ||= @search_cache.search permitted_search_params[:page]
        rescue Errno::ECONNREFUSED
          @articles ||= policy_scope(Article).page permitted_search_params[:page]
        end
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
      hash = params.permit(:page, :q, article_search_form: ArticleSearchForm.article_search_form_attrs)
      hash.merge article_search_form: { category_id: resource.id }
    end
end
