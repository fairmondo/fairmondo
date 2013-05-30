class UsersController < InheritedResources::Base
  before_filter :authenticate_user!

  actions :show
  custom_actions :resource => :profile

  before_filter :authorize_resource

  def authorize_resource
    authorize resource
  end

end
