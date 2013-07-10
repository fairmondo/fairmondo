#
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class ApplicationController < ActionController::Base

  ## Global security

  before_filter :authenticate_user!

  # Pundit
  include Pundit
  after_filter :verify_authorized_with_exceptions, :except => [:index]

  protect_from_forgery

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

  protected

  def render_users_hero
    render_hero :controller => "users"
  end

  def render_hero options
    options[:action] ||= "default"
    options[:controller] ||= params[:controller]
    @rendered_hero = options
  end

  # Pundit checker

  def verify_authorized_with_exceptions
    verify_authorized unless pundit_unverified_controller
  end

  def pundit_unverified_controller
    (pundit_unverified_modules.include? self.class.name.split("::").first) || (pundit_unverified_classes.include? self.class)
  end

  def pundit_unverified_modules
    ["Devise","RailsAdmin","Tinycms"]
  end

  def pundit_unverified_classes
    [RegistrationsController, SessionsController, ToolboxController]
  end


  # Caching security: Set response headers to prevent caching
  # @api semipublic
  # @return [undefined]
  def dont_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

end
