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
    @cart_checkout_form = CartCheckoutForm.new(session[:cart_checkout], @cart) #try the old session data

    if @cart_checkout_form.complete?
      render :overview
    else
      render :edit
    end
  end


  # buy cart
  def update
    debugger
    @cart_checkout_form = CartCheckoutForm.new(session[:cart_checkout], @cart)
    @cart_checkout_form.update(params.for(@cart_form).refine)
    respond_with @cart
  end

  private

    def generate_session
      session[:cart_data] ||= {}
    end

    def set_cart
      @cart = Cart.includes( line_item_groups: [ :seller, { line_items: { business_transaction:  [:article] }}]).find params[:id]
    end

end
