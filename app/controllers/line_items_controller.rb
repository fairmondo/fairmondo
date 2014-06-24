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
    @line_item = LineItem.new params.for(LineItem).refine
    @line_item.line_item_group = find_or_create_line_item_group

    authorize @line_item
    @line_item.save

    respond_with @line_item, location: @line_item.line_item_group.cart
  end

  def update

  end

  def destroy

  end

  private
    def find_or_create_line_item_group
      cart = Cart.find(cookies[:cart]) rescue Cart.current_or_new_for(current_user) # find cart from cookie or get one
      cookies[:cart] = cart.id # set cookie anew
      cart.line_item_group_for @line_item.business_transaction.seller # get the seller-unique LineItemGroup (or creates one)
    end
end
