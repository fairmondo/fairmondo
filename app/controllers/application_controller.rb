class ApplicationController < ActionController::Base
  include Pundit

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
      flash.discard
      "/banned"
    else
      stored_location_for(resource_or_scope) || user_path(resource_or_scope)
    end
  end

  def tinycms_admin?
    current_user && current_user.admin?
  end

  ## programmatically get controller's filters
  # def self.filters(kind = nil)
  #   all_filters = _process_action_callbacks
  #   all_filters = all_filters.select{|f| f.kind == kind} if kind
  #   all_filters.map { :filter }
  # end
  def self.has_before_filter_of_type? filter, action_name = nil
    all_filters = _process_action_callbacks
    filter_hash = all_filters.select{ |f| f.kind == :before && f.filter == filter }[0].per_key

    if filter_hash && action_name
      # print filter_hash
      # print action_name
      if filter_hash[:unless]
        !eval(filter_hash[:unless][0]) # these describe actions excluded from the filter. returns true => action doesnt have filter
      elsif filter_hash[:if]
        eval(filter_hash[:if][0]) # these describe actions including the filter. returns true => action has filter
      else
        true # everyone gets the before filter
      end
    else
      false
    end
  end


  protected

  def render_users_hero
    render_hero :controller => "users"
  end

  def render_hero options
    options[:action] ||= "default"
    options[:controller] ||= params[:controller]
    @rendered_hero = options
  end




end
