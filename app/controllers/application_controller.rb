#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ApplicationController < ActionController::Base
  ## Global security
  before_action :authenticate_user!

  ## Global actions
  before_action :unset_cart
  before_action :profile_request

  ## Affiliate Network
  include BelboonTracking
  before_action :save_belboon_tracking_token_in_session, only: [:index, :show]

  layout :layout_by_param

  # Arcane
  include Arcane

  # Pundit
  include Pundit
  after_action :verify_authorized_with_exceptions, except: [:index, :feed, :ipn_notification, :contact]

  include BrowsingHistory # (lib/autoload) browsing history for redirects and feedback
  after_action :store_location

  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?

  helper :all

  # Customize the Devise after_sign_in_path_for() for redirect to previous page after login
  def after_sign_in_path_for resource_or_scope
    after_sign_in_if_banned(resource_or_scope) ||
      after_sign_in_if_ajax ||
      after_sign_in_if_sepa_required(resource_or_scope) ||
      stored_location_for(resource_or_scope) ||
      redirect_back_location ||
      user_path(resource_or_scope)
  end

  protected

  def json_request?
    request.format.json?
  end

  # Pundit checker

  def verify_authorized_with_exceptions
    verify_authorized unless pundit_unverified_controller
  end

  def pundit_unverified_controller
    (pundit_unverified_modules.include? self.class.name.split('::').first) || (pundit_unverified_classes.include? self.class.name)
  end

  def pundit_unverified_modules
    %w(Devise RailsAdmin)
  end

  def pundit_unverified_classes
    [
      'RegistrationsController', 'SessionsController', 'ConfirmationsController', 'ToolboxController',
      'BankDetailsController', 'ExportsController', 'WelcomeController',
      'CategoriesController', 'Peek::ResultsController', 'StyleguidesController',
      'RemoteValidationsController', 'DiscourseController'
    ]
  end

  def build_search_cache
    search_params = {}
    form_search_params = params.for(ArticleSearchForm)[:article_search_form]
    search_params.merge!(form_search_params) if form_search_params.is_a?(Hash)
    @search_cache = ArticleSearchForm.new(search_params)
  end

  # Caching security: Set response headers to prevent caching
  # @api semipublic
  # @return [undefined]
  def dont_cache
    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

  # If user wants to sell
  def ensure_complete_profile
    # Check if the user has filled all fields
    unless current_user.can_sell?
      flash[:error] = t('article.notices.incomplete_profile')
      redirect_to edit_user_registration_path(incomplete_profile: true)
    end
  end

  def check_value_of_goods
    current_user.count_value_of_goods
    if value_of_goods_exceeded?
      flash[:error] = I18n.t('article.notices.max_limit')
      redirect_to user_path(current_user)
    end
  end

  def render_css_from_controller controller
    @controller_specific_css = controller
  end

  def unset_cart
    # gets called on every page load. when a session has expired, the old cart cookie needs to be cleared
    if !current_user && cookies[:cart] && !view_context.current_cart
      # if no user is logged in and there is a cart cookie but that cart can't be found / wasn't allowed
      cookies.delete :cart
    end
  end

  def profile_request
    Rack::MiniProfiler.authorize_request if current_user && current_user.admin?
  end

  private

  def layout_by_param
    if params[:iframe]
      'iframe'
    else
      nil
    end
  end

  def after_sign_in_if_banned resource_or_scope
    if resource_or_scope.is_a?(User) && resource_or_scope.banned?
      sign_out resource_or_scope
      flash.discard
      '/banned'
    end
  end

  def after_sign_in_if_ajax
    toolbox_reload_path if request.xhr?
  end

  def after_sign_in_if_sepa_required user
    # If a legal Entity hasn't accepted direct debit but has any articles
    if user.is_a?(LegalEntity) && !user.direct_debit &&
       Article.unscoped.where(seller: user).limit(1).count > 0

      flash[:error] = t('users.notices.sepa_missing')
      '/user/edit?incomplete_profile=true'
    end
  end

  def value_of_goods_exceeded?
    current_user.value_of_goods_cents > (current_user.max_value_of_goods_cents + current_user.max_value_of_goods_cents_bonus)
  end
end
