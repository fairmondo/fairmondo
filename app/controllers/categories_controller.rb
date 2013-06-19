class CategoriesController < InheritedResources::Base

  actions :show

  before_filter :authorize_resource

  def authorize_resource
    authorize resource
  end

  def show
    show! do |format|
      format.json { render :json => resource.to_json(:include => :children) }
    end
  end

  respond_to :json,:js

end