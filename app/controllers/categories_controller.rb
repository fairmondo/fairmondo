class CategoriesController < InheritedResources::Base
  actions :show, :index
  custom_actions resource: :show_json

  skip_before_filter :authenticate_user!

  def show
    show! do
      begin
        @search_cache = ArticleSearchForm.new permitted_search_params[:article_search_form]
        @articles ||= @search_cache.search permitted_search_params[:page]
      rescue Errno::ECONNREFUSED
        @articles ||= policy_scope(Article).page permitted_search_params[:page]
      end
    end
  end

  def show_json
    @children = resource.children
    @children = @children.delete_if { |child| child.children.empty? && child.active_articles.empty? } if params[:hide_empty]
    render json: @children.map { |child| {id: child.id, name: child.name} }.to_json
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
      hash[:article_search_form] ||= {}
      hash[:article_search_form][:category_id] = resource.id
      hash
    end
end
