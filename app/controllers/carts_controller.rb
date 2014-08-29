class CartsController < ApplicationController
  respond_to :html

  before_filter :generate_session, only: :edit
  before_filter :clear_session, only: :show # userhas the possibility to reset the session by continue buying
  before_filter :set_cart
  before_filter :dont_cache, only: [:edit, :update]

  before_filter :authorize_and_authenticate_user_on_cart, only: :show
  skip_before_filter :authenticate_user!, only: :show


  def show
    if @cart.sold? and @cart.line_item_groups.count == 1
      # redirect directly to a purchase view if there is only one lig to purchase
      redirect_to @cart.line_item_groups.first
    else
      @cart_abacus = CartAbacus.new @cart
      @line_items_valid = all_line_items_valid?
      respond_with @cart
      # switch between pre and post purchase view happens in the template
    end
  end

  def edit
    authorize @cart
    @cart_checkout_form = CartCheckoutForm.new(session, @cart, params[:checkout]) #try the old session data
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
      # DO NOT PUT ANY CODE HERE THAT CAN FAIL !!!! #####
      # Best would be not to put any code here at all.
      # If you have to do something here that can fail
      # put it into the transaction of Cart#buy.
      ###################################################
      clear_session
      flash[:notice] = I18n.t('cart.notices.checkout_success') if @cart.save
      cookies.delete :cart
      respond_with @cart
    when :checkout_failed
      # failed because something isnt available anymore
      flash[:error] = I18n.t('cart.notices.checkout_failed')
      respond_with @cart
    end
  end

  private

    def generate_session
      session[:cart_checkout] ||= {}
    end

    def clear_session
      session[:cart_checkout] = nil
    end

    def set_cart
      @cart = Cart.includes(
        line_item_groups:[
          :seller,
          :business_transactions,
          :transport_address,
          :payment_address,
          {line_items:{
            article:[
              :seller,
              :images
        ]}}]).find params[:id]
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
end
