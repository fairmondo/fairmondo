class UsersController < InheritedResources::Base
  before_filter :authenticate_user!

  actions :show
  custom_actions :resource => :profile

end
