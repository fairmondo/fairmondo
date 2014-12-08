#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
class PaymentsController < ApplicationController
  respond_to :html

  # create happens on buy. this is to initialize the payment with paypal
  def create
    params[:payment].merge!(line_item_group_id: params[:line_item_group_id])
    payment_attrs = params.for(Payment).refine
    @payment = Payment.new payment_attrs
    authorize @payment
    if @payment.execute
      redirect_to @payment.after_create_path
    else
      redirect_to :back, flash: { error: I18n.t("#{@payment.type}.controller_error", email: @payment.line_item_group_seller_paypal_account).html_safe }
    end
  end

  def show
    @payment = Payment.find(params[:id])
    authorize @payment
    redirect_to PaypalAPI.checkout_url @payment.pay_key
  end
end
