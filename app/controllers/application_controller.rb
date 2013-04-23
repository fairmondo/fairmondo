class ApplicationController < ActionController::Base
  protect_from_forgery
  def build_login
    @login = render_to_string(:partial => "devise/login_popover" , :layout => false )
  end
 
  helper :all
  helper_method :tinycms_admin?

  # Customize the Devise after_sign_in_path_for() for redirect to previous page after login
  def after_sign_in_path_for(resource_or_scope)

    if resource_or_scope.is_a?(User) && resource_or_scope.banned?
      sign_out resource_or_scope
      "/banned"
    else
      stored_location_for(resource_or_scope) || dashboard_path
    end
  end

  def tinycms_admin?
    current_user && current_user.admin?
  end
 

  private

  def setup_categories
    @categories = Category.roots
  end

end
