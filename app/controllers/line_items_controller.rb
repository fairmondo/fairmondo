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
class LineItemsController < ApplicationController
  respond_to :html
  responders :location

  skip_before_filter :authenticate_user!, only: [:create, :update, :destroy]

  def create
    @line_item = LineItem.find_or_new params.for(LineItem).refine, find_or_create_cart.id

    if @line_item.new_record?
      @line_item.line_item_group = find_or_create_line_item_group
    else
      @line_item.update_attribute :requested_quantity, params['line_item']['requested_quantity']
    end

    authorize @line_item

    flash[:notice] = I18n.t('line_item.notices.success_create') if @line_item.save
    redirect_to @line_item.article
  end

  def update
    @line_item = LineItem.find(params[:id])
    @line_item.cart_cookie = cookies.signed[:cart]
    authorize @line_item

    unless @line_item.update(params.for(@line_item).refine)
      flash[:error] = I18n.t('line_item.notices.error_update')
    end

    cart = Cart.find(cookies.signed[:cart])
    refresh_cookie cart
    redirect_to cart
  end

  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.cart_cookie = cookies.signed[:cart]
    authorize @line_item
    @line_item.destroy

    cart = Cart.find(cookies.signed[:cart])
    refresh_cookie cart
    redirect_to cart
  end

  private
    def find_or_create_cart
      @cart = Cart.find(cookies.signed[:cart]) rescue Cart.current_or_new_for(current_user) # find cart from cookie or get one
      refresh_cookie @cart # set cookie anew
      @cart
    end

    def find_or_create_line_item_group
      @cart.line_item_group_for @line_item.article.seller # get the seller-unique LineItemGroup (or creates one)
    end

    def refresh_cookie cart
      cookies.signed[:cart] = { value: cart.id, expires: 30.days.from_now }
    end
end
