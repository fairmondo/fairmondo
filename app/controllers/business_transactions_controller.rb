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
class BusinessTransactionsController < ApplicationController
  respond_to :html

  before_filter :set_business_transaction
  before_filter :redirect_if_already_sold, only: [:edit, :update]
  before_filter :redirect_if_not_yet_sold, only: :show, unless: :multiple?
  before_filter :redirect_to_child_show, only: :show, if: :multiple?
  before_filter :dont_cache

  def edit
    authorize @business_transaction
    @business_transaction.billing_address = current_user.standard_address || Address.new
    render :step2 if request.patch? && @business_transaction.edit_params_valid?(params.for(@business_transaction).refine)
    debugger
    nil
  end

  def show
    authorize @business_transaction
  end

  def already_sold
    authorize @business_transaction
  end

  def print_order_buyer
    authorize @business_transaction
    render :print_order_buyer, layout: false
  end

  def update
    @business_transaction.assign_attributes(params.for(@business_transaction).refine)
    @business_transaction.shipping_address = @business_transaction.billing_address unless params[:shipping_address_id]
    @business_transaction.buyer_id = current_user.id
    authorize @business_transaction
    if @business_transaction.valid? && @business_transaction.buy
      respond_with @business_transaction
    elsif @business_transaction.edit_params_valid?(params.for(@business_transaction).refine)
      render :step2
    else
      render :edit
    end
  end

  private
    ## show ##
    def redirect_if_not_yet_sold
      if @business_transaction.available? && ( !@business_transaction.buyer || !@business_transaction.buyer.is?(current_user) )
        redirect_to edit_business_transaction_path(@business_transaction)
      end
    end

    def redirect_to_child_show
      if @business_transaction.children
        child_transactions = @business_transaction.children.select { |c| c.buyer == current_user }
        unless child_transactions.empty?
          redirect_to business_transaction_path child_transactions[-1]
        end
      end
    end

    ## edit, update ##
    def redirect_if_already_sold
      redirect_to already_sold_business_transaction_path(@business_transaction) unless @business_transaction.available?
    end

    ## other ##
    def multiple?
      @business_transaction.multiple?
    end

    def set_business_transaction
      @business_transaction = BusinessTransaction.find(params[:id])
    end
end
