class CategoriesController < InheritedResources::Base

  actions :show,:index

  before_filter :authorize_resource, :only => :show
  skip_before_filter :authenticate_user!

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

  respond_to :json,:js
end
