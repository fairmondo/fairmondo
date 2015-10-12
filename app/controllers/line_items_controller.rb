#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LineItemsController < ApplicationController
  respond_to :html
  respond_to :json, only: [:create]
  responders :location

  skip_before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :quantity_zero_means_destroy, only: [:update]

  def create
    @line_item = LineItem.find_or_new params.for(LineItem).refine, find_or_create_cart.id

    begin
      @line_item.transaction do
        @line_item.prepare_line_item_group_or_assign @cart, params['line_item']['requested_quantity']
        authorize @line_item
        @line_item.save!
      end
      flash[:notice] = I18n.t('line_item.notices.success_create', href: cart_path(@cart)).html_safe
    rescue
      flash[:error] = I18n.t('line_item.notices.error_quantity')
    end

    respond_with @line_item.article
  end

  def update
    find_and_authorize_line_item

    unless @line_item.update(params.for(@line_item).refine)
      flash[:error] = I18n.t('line_item.notices.error_quantity')
    end

    set_cart
    respond_to do |format|
      format.html { redirect_to @cart }
      format.js { @cart_abacus = CartAbacus.new @cart }
    end
  end

  def destroy
    find_and_authorize_line_item
    @line_item.destroy
    set_cart
    redirect_to @cart
  end

  private

  def find_or_create_cart
    @cart = Cart.find(cookies.signed[:cart]) rescue Cart.current_or_new_for(current_user) # find cart from cookie or get one
    refresh_cookie @cart # set cookie anew
    @cart
  end

  def find_and_authorize_line_item
    @line_item = LineItem.lock(true).find(params[:id])
    @line_item.cart_cookie = cookies.signed[:cart]
    authorize @line_item
  end

  def set_cart
    @cart = Cart.find(cookies.signed[:cart])
    refresh_cookie @cart
  end

  def refresh_cookie cart
    cookies.signed[:cart] = { value: cart.id, expires: 30.days.from_now }
  end

  # called before update
  def quantity_zero_means_destroy
    if params[:line_item] && params[:line_item][:requested_quantity] == '0'
      destroy
    end
  end
end
