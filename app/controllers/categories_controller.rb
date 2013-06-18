class CategoriesController < InheritedResources::Base
  
  actions :show
  
  before_filter :authorize_resource
  
  def authorize_resource
    authorize resource
  end
  
  respond_to :js

end