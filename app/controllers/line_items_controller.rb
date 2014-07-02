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
    @line_item = LineItem.find_or_new params.for(LineItem).refine

    if @line_item.new_record?
      @line_item.line_item_group = find_or_create_line_item_group
    else
      @line_item.requested_quantity += 1
    end

    authorize @line_item

    flash[:notice] = 'Der Artikel wurde dem Warenkorb hinzugefügt' if @line_item.save
    redirect_to @line_item.article
  end

  def update

  end

  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.cart_hash = cookies[:cart]
    authorize @line_item
    @line_item.destroy
    redirect_to Cart.find_by_unique_hash(cookies[:cart])
  end

  private
    def find_or_create_line_item_group
      cart = Cart.find_by_unique_hash!(cookies[:cart]) rescue Cart.current_or_new_for(current_user) # find cart from cookie or get one
      cookies[:cart] = cart.unique_hash # set cookie anew
      cart.line_item_group_for @line_item.article.seller # get the seller-unique LineItemGroup (or creates one)
    end
end
