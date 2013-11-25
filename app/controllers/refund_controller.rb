class RefundController < InheritedResources::Base
  respond_to :html
  actions :show, :create
  before_filter :authorize_resource

  def show
  end
  
  def create
  end
end
