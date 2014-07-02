class CartsController < ApplicationController
  respond_to :html

  before_filter :generate_session, only: :edit
  before_filter :set_cart

  skip_before_filter :authenticate_user!, only: :show

  def show
    authorize @cart
    respond_with @cart
  end

  def edit
    authorize @cart
    @cart_checkout_form = CartCheckoutForm.new(session, @cart, params[:checkout]) #try the old session data
    if @cart_checkout_form.session_valid? && params[:checkout]
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
      clear_session
      respond_with @cart
    when :checkout_failed
      # failed becausesomething isnt available anymore
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
      @cart = Cart.includes( line_item_groups: [ :seller, { line_items:  [:article] }]).find params[:id]
    end

end
