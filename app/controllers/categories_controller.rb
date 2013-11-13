class CategoriesController < InheritedResources::Base

  actions :show,:index

  skip_before_filter :authenticate_user!
  respond_to :json,:js, :only => :show
  respond_to :html, :only => :index

  def show
    show! do |format|
      format.json do
        return_hash = resource.children.map { |child| {id: child.id, name: child.name} }
        render :json => return_hash.to_json()
      end
    end
  end

  def collection
    @categories ||= Category.sorted_roots.includes(:children)
  end


end
