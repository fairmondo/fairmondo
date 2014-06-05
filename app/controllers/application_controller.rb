#
#
# == License:
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

  # Arcane
  include Arcane

  # Pundit
  include Pundit
  after_filter :verify_authorized_with_exceptions, :except=> [:index,:feed]

  protect_from_forgery

  helper :all

  # Customize the Devise after_sign_in_path_for() for redirect to previous page after login
  def after_sign_in_path_for resource_or_scope
    if resource_or_scope.is_a?(User) && resource_or_scope.banned?
      sign_out resource_or_scope
      flash.discard
      "/banned"
    elsif request.xhr? # AJAX request
      toolbox_reload_path
    else
      stored_location_for(resource_or_scope) || user_path(resource_or_scope)
    end
  end

  # Return path with fallback
  # @api public
  # @param fallback [String] path
  # @param options [Hash] (is this really needed?)
  # @return [String] return path
  def return_to_path fallback, options = {}
    return session.delete(:return_to) || fallback if options[:clear]
    session[:return_to] || fallback
  end

  protected

    def render_users_hero
      render_hero controller: "users"
    end

    def render_hero options
      options[:action] ||= "default"
      options[:controller] ||= params.permit(:controller)[:controller]
      @rendered_hero = options
    end

    # Pundit checker

    def verify_authorized_with_exceptions
      verify_authorized unless pundit_unverified_controller
    end

    def pundit_unverified_controller
      (pundit_unverified_modules.include? self.class.name.split("::").first) || (pundit_unverified_classes.include? self.class.name)
    end

    def pundit_unverified_modules
      ["Devise","RailsAdmin"]
    end

    def pundit_unverified_classes
      [
       "RegistrationsController", "SessionsController", "ToolboxController",
       "BankDetailsController", "ExportsController", "WelcomeController",
       "CategoriesController", "Peek::ResultsController", "StyleguidesController"
      ]
    end

    def refined_params
      @refined_params ||= params.for(appropriate_resource).as(current_user).refine
    end

    # resource or build_resource, whatever succeeds first. to be used in functions
    # that are used in different actions and sometimes need one or the other
    def appropriate_resource #merge_options = {}
      resource rescue build_resource
      # resource.update_attributes merge_options
      # resource
    end

    def build_search_cache
      @search_cache = ArticleSearchForm.new(params.for(ArticleSearchForm)[:article_search_form])
    end

    # Caching security: Set response headers to prevent caching
    # @api semipublic
    # @return [undefined]
    def dont_cache
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end

    # If user wants to sell
    def ensure_complete_profile
      # Check if the user has filled all fields
      if !current_user.can_sell?
        flash[:error] = t('article.notices.incomplete_profile')
        redirect_to edit_user_registration_path(:incomplete_profile => true)
      end
    end

    def check_value_of_goods
      current_user.count_value_of_goods
      if current_user.value_of_goods_cents > ( current_user.max_value_of_goods_cents + current_user.max_value_of_goods_cents_bonus )
        redirect_to user_path(current_user), alert: I18n.t('article.notices.max_limit')
      end
    end

    def render_css_from_controller controller
      @controller_specific_css = controller
    end



end
