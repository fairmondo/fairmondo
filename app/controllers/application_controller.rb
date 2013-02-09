class ApplicationController < ActionController::Base
  protect_from_forgery
  def build_login
    @login = render_to_string(:partial => "devise/login_popover" , :layout => false )
  end

  helper :all

  # Customize the Devise after_sign_in_path_for() for redirect to previous page after login
  def after_sign_in_path_for(resource_or_scope)

    if resource_or_scope.is_a?(User) && resource_or_scope.banned?
      sign_out resource_or_scope
      "/banned"
    else
      if get_stored_location
        store_location = get_stored_location
        clear_stored_location
        (store_location.nil?) ?  dashboard_path : store_location.to_s
      else
        dashboard_path
      end
    end
  end

  def tinycms_admin?
    current_user && current_user.admin?
  end
  helper_method :tinycms_admin?

# commented because currently not used see #156
=begin 1
  # Useful Set of Methods for Storing Objects for session initiation
  def deny_access_to_save_object serialized_object, path = request.path
    flash[:warning] = t('devise.failure.unauthenticated')
    session[:return_to] = path
    session[:stored_object_id] = serialized_object
    redirect_to new_user_session_path
  end

  def clear_stored_object
    session[:stored_object_id] = nil
  end

  def get_stored_object
    session[:stored_object_id]
  end
=end
  
  def clear_stored_location
    session[:return_to] = nil
  end

  def get_stored_location
    session[:return_to]
  end

  before_filter :load_faqs
  
  
  private

  def load_faqs
    @faqs = Faq.scoped
  end
  
  def setup_categories
    @categories = Category.roots
  end

end
