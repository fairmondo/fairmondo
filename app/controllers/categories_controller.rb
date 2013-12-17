class CategoriesController < InheritedResources::Base

  actions :show,:index

  skip_before_filter :authenticate_user!
  respond_to :json,:js, :only => :show
  respond_to :html, :only => :index

  def show
    @children = resource.children
    @children = @children.delete_if { |child| child.children.empty? && child.active_articles.empty? } if params[:hide_empty]
    show! do |format|
      format.json do
        render :json => @children.map { |child| {id: child.id, name: child.name} }.to_json
      end
    end
  end

  def collection
    @categories ||= Category.sorted_roots.includes(:children)
  end

  def id_index
    @categories = Category.all_by_id
  end
end
