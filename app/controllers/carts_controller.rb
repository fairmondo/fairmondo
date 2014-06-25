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
    @cart_checkout_form = CartCheckoutForm.new(session[:cart_checkout], @cart)
    result = @cart_checkout_form.process(params[:cart_checkout_form])
    case result
    when :invalid
      render :edit
    when :saved_in_session
      redirect_to edit_cart_path
    when :checked_out
      respond_with @cart
    end
  end

  private

    def generate_session
      session[:cart_checkout] ||= {}
    end

    def set_cart
      @cart = Cart.includes( line_item_groups: [ :seller, { line_items: { business_transaction:  [:article] }}]).find params[:id]
    end

end
