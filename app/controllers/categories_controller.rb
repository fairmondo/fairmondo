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
    @categories ||= Category.other_category_last.sorted_roots.includes(children: {children: :children})
  end

  private
    def get_articles
      begin
        @search_cache = ArticleSearchForm.new permitted_search_params[:article_search_form]
        @articles ||= @search_cache.search permitted_search_params[:page]
      rescue Errno::ECONNREFUSED
        @articles ||= policy_scope(Article).page permitted_search_params[:page]
      end
    end

    def permitted_search_params
      hash = params.permit(:page, :q, article_search_form: ArticleSearchForm.article_search_form_attrs)
      hash[:article_search_form] ||= {}
      hash[:article_search_form][:category_id] = resource.id
      hash
    end

    def as_json
      @children = resource.children
      @children = @children.delete_if { |child| child.children.empty? && child.active_articles.empty? } if params[:hide_empty]
      render json: @children.map { |child| {id: child.id, name: child.name} }.to_json
    end
end
