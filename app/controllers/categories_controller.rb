class CategoriesController < InheritedResources::Base

  actions :show

  before_filter :authorize_resource
  skip_before_filter :authenticate_user!

  def show
    show! do |format|
      format.html do
        render :layout => false;
      end
      format.json do
        return_hash = resource.children.map { |child| {id: child.id, name: child.name} }
        render :json => return_hash.to_json()
      end
    end
  end

  respond_to :json,:js,:html
end
