#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class CartsController < ApplicationController
  respond_to :html
  respond_to :js, if: lambda { request.xhr? }

  before_action :generate_session, only: :edit
  before_action :clear_session, only: :show # userhas the possibility to reset the session by continue buying
  before_action :set_cart
  before_action :dont_cache, only: [:edit, :update]

  before_action :authorize_and_authenticate_user_on_cart, only: [:show, :send_via_email]
  skip_before_action :authenticate_user!, only: [:show, :send_via_email, :empty_cart]

  def show
    if @cart.sold?
      # redirect directly to a purchase view if there is only one lig to purchase
      return redirect_to @cart.line_item_groups.first if @cart.line_item_groups.count == 1
    else
      reject_orphaned_line_items
      @cart_abacus = CartAbacus.new @cart
      @line_items_valid = all_line_items_valid?
    end
    respond_with @cart
    # switch between pre and post purchase view happens in the template
    clear_belboon_tracking_token_from_user if clear_tracking_token?
  end

  def edit
    authorize @cart
    @cart_checkout_form = CartCheckoutForm.new(session, @cart, params[:checkout]) # try the old session data
    if !all_line_items_valid?
      redirect_to cart_path @cart
    elsif @cart_checkout_form.session_valid? && params[:checkout]
      prepare_overview_variables
      render :overview
    else
      render :edit
    end
  end

  # buy cart
  def update
    authorize @cart
    @cart_checkout_form = CartCheckoutForm.new(session, @cart, params[:checkout])
    result = @cart_checkout_form.process(params[:cart_checkout_form])

    case result
    when :invalid
      render :edit
    when :saved_in_session
      redirect_to edit_cart_path(@cart, checkout: true)
    when :checked_out
      ###################################################
      # DO NOT PUT ANY CODE HERE THAT CAN FAIL !!!!     #
      # Best would be not to put any code here at all.  #
      # If you have to do something here that can fail  #
      # put it into the transaction of Cart#buy.        #
      ###################################################
      clear_session
      set_donation_flash if @cart.save
      cookies.delete :cart
      respond_with @cart
    when :checkout_failed
      # failed because something isnt available anymore
      flash[:error] = I18n.t('cart.notices.checkout_failed')
      respond_with @cart
    end
  end

  def empty_cart
    authorize @cart
    render :empty_cart
  end

  def send_via_email
    authorize @cart
    if params && params[:email]
      CartMailer.send_cart(@cart, params[:email][:email]).deliver
      render :send_via_email
    else
      render layout: false
    end
  end

  private

  def generate_session
    session[:cart_checkout] ||= {}
  end

  def clear_session
    session[:cart_checkout] = nil
  end

  def reject_orphaned_line_items
    orphaned = @cart.line_items.select(&:orphaned?).each(&:destroy)
    if orphaned.any? # reload cart
      set_cart
    end
  end

  def set_cart
    begin
      @cart = Cart.includes(
        line_item_groups: [
          :seller,
          :business_transactions,
          :transport_address,
          :payment_address,
          { line_items: {
            article: [
              :seller,
              :title_image
            ] } }]).find(params[:id])
    rescue
      @cart = Cart.new
    end
  end

  def authorize_and_authenticate_user_on_cart
    if @cart.user_id # cart belongs to user
      authenticate_user! # and can only be accessed by a logged in user
    else # otherwise
      @cart.cookie_content = cookies.signed[:cart] # we need the cookie content to authorize the cart
    end

    authorize @cart
  end

  def prepare_overview_variables
    @abaci = @cart.line_item_groups.map { |group| Abacus.new(group) }
    @total = @abaci.map(&:total).sum
  end

  def all_line_items_valid?
    @cart.line_item_groups.map(&:line_items).flatten.all?(&:valid?)
  end

  def set_donation_flash
    total_donations = @cart.user.reload.total_purchase_donations
    if total_donations == 0
      flash[:notice] = I18n.t('cart.notices.checkout_success_no_donation')
    else
      flash[:notice] = I18n.t(
        'cart.notices.checkout_success', euro: total_donations
      ).html_safe
    end
  end

  def clear_tracking_token?
    @cart && @cart.sold?
  end
end
